#!/bin/bash

# Set environment variables for the addresses of each chain
SEPOLIA_ADDRESS="0xa52b9555afe63bfBa09291Cd0a0F36B6bBd69e04"
OPTIMISM_SEPOLIA_ADDRESS="0xC288fc507F1b21aCEC344662BfDF8A42bC5b81D5"
BASE_SEPOLIA_ADDRESS="0x0139CA09B21Bb12ec83556c375e86DDff37592E1"

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
cat > "config/factory.json" <<EOL
{
  "name": "factory/1.0.0",
  "version": "1",
  "abis": {
    "factory": {
      "path": "../abis/factory.json"
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
  cat >> "config/factory.json" <<EOL
    {
      "abi": "factory",
      "address": "$address",
      "startBlock": $start_block,
      "chain": "$chain"
    },
EOL
done

# Remove the trailing comma from the last instance
sed -i '' -e '$s/,$//' "config/factory.json"

# Close the instances array and the configuration file
echo '  ]' >> "config/factory.json"
echo '}' >> "config/factory.json"

echo "Generated configuration file: config/factory.json"

# Deploy the subgraph using the configuration file
goldsky subgraph deploy "factory/1.0.0" --from-abi "./config/factory.json"