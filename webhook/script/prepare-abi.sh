#!/bin/bash

## please not use proxy contract
# Array of URLs to retrieve ABI files from
urls=(
  "https://api-sepolia.basescan.org/api?module=contract&action=getabi&address=0xE5aDec624bD19973B5418237201C58351448A15a"
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