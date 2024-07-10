#!/bin/bash

# Set the URL for the webhook
WEBHOOK_URL="https://signal-data-vercel.vercel.app/api/post"

# Array of chain names and corresponding environment variables for addresses
chains=(
  "sepolia:SEPOLIA_ADDRESS"
  "optimism-sepolia:OPTIMISM_SEPOLIA_ADDRESS"
  "base-sepolia:BASE_SEPOLIA_ADDRESS"
)

# Iterate over each chain and create the webhook
for chain_info in "${chains[@]}"
do
  IFS=':' read -ra chain_parts <<< "$chain_info"
  chain="${chain_parts[0]}"
  
  # Create the webhook for the subgraph
  goldsky subgraph webhook create "cred-${chain}/1.0.0" --name "cred-${chain}-webhook" --entity "cred_created" --url "$WEBHOOK_URL"
  
  echo "Created webhook for subgraph: cred-${chain}/1.0.0"
done