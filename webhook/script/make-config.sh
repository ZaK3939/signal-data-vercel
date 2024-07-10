#!/bin/bash

# Set environment variables for the addresses of each chain
SEPOLIA_ADDRESS="0x997F120c1dd889f6E73F09cD7712e014d32Db620"
OPTIMISM_SEPOLIA_ADDRESS="0x8FF5d8309BC48487cF8489a3145fa3a2e2cB1074"
BASE_SEPOLIA_ADDRESS="0x624A242D4C7215573418745B0dE6f4b6b1C6beFF"

# Array of chain names and corresponding environment variables for addresses
chains=(
  "sepolia:SEPOLIA_ADDRESS"
  "optimism-sepolia:OPTIMISM_SEPOLIA_ADDRESS"
  "base-sepolia:BASE_SEPOLIA_ADDRESS"
)

# Function to retrieve the current block number for a given chain
get_current_block() {
  local chain=$1
  case $chain in
    "sepolia")
      curl -s "https://api-sepolia.etherscan.io/api?module=proxy&action=eth_blockNumber" | jq -r '.result' | xargs printf "%d\n"
      ;;
    "optimism-sepolia")
      curl -s "https://api-sepolia-optimism.etherscan.io/api?module=proxy&action=eth_blockNumber" | jq -r '.result' | xargs printf "%d\n"
      ;;
    "base-sepolia")
      curl -s "https://api-sepolia.basescan.org/api?module=proxy&action=eth_blockNumber" | jq -r '.result' | xargs printf "%d\n"
      ;;
    *)
      echo "Unknown chain: $chain"
      exit 1
      ;;
  esac
}


# Generate the JSON configuration file
cat > "config/cred.json" <<EOL
{
  "name": "cred/1.0.0",
  "version": "1",
  "abis": {
    "cred": {
      "path": "../abis/cred.json"
    }
  },
  "instances": [
EOL

# Iterate over each chain and add the instance to the configuration file
for chain_info in "${chains[@]}"
do
  IFS=':' read -ra chain_parts <<< "$chain_info"
  chain="${chain_parts[0]}"
  address_var="${chain_parts[1]}"
  
  # Get the address from the environment variable
  address="${!address_var}"
  
  # Get the current block number for the chain
  start_block=$(get_current_block "$chain")
  
  # Add the instance to the configuration file
  cat >> "config/cred.json" <<EOL
    {
      "abi": "cred",
      "address": "$address",
      "startBlock": $start_block,
      "chain": "$chain"
    },
EOL
done

# Remove the trailing comma from the last instance
sed -i '' -e '$s/,$//' "config/cred.json"

# Close the instances array and the configuration file
echo '  ]' >> "config/cred.json"
echo '}' >> "config/cred.json"

echo "Generated configuration file: config/cred.json"

# Deploy the subgraph using the configuration file
goldsky subgraph deploy "cred/1.0.0" --from-abi "./config/cred.json"