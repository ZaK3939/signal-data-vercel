#!/bin/bash

# Array of URLs to retrieve ABI files from
urls=(
  "https://api-sepolia.basescan.org/api?module=contract&action=getabi&address=0xE5aDec624bD19973B5418237201C58351448A15a"
#   "https://api-sepolia-optimism.etherscan.io/api?module=contract&action=getabi&address=0x00c9b13ac9cf7a2665890bf147d3ac932af9fc96"
#   "https://api-sepolia.etherscan.io/api?module=contract&action=getabi&address=0x2d090a33ab56fc0b8a69611a12a79db9b45ac9f0"
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
  output_file="${output_dir}/cred.json"
  
  # Retrieve the ABI file and save it
  curl -s "$url" | jq -r '.result' > "$output_file"
  
  echo "ABI file saved: $output_file"
done