#!/bin/bash

# Set the Addrss for retrieve ABI files from scan
## please not use proxy contract
BASE_SEPOLIA_ADDRESS="0x13ecc4d2f025b4d321e0b472abd346e9c2a88590"
urls=(
"https://api-sepolia.basescan.org/api?module=contract&action=getabi&address=$BASE_SEPOLIA_ADDRESS"
)
# Output directory for saving ABI files
output_dir="abis"

# Create the output directory if it doesn't exist
if [ ! -d "$output_dir" ]; then
  mkdir "$output_dir"
fi

# Retrieve and save ABI files from each URL
for url in "${urls[@]}"
do
  # Extract the address from the URL
  address=$(echo "$url" | sed -E 's/.*address=([a-zA-Z0-9]+).*/\1/')
  
  # Output file name
  output_file="${output_dir}/factory.json"
  
  # Retrieve the ABI file and save it
  curl -s "$url" | jq -r '.result' > "$output_file"
  
  echo "ABI file saved: $output_file"
done