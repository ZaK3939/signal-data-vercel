#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <client_id> <client_secret>"
    exit 1
fi

client_id="$1"
client_secret="$2"

offset=0
total=0
projects=()

while true; do
    response=$(curl --request GET \
        --url "https://apis.thedapplist.com/v1/proposals?offset=$offset" \
        --header 'accept: application/json' \
        --header "client-id: $client_id" \
        --header "client-secret: $client_secret")

    total=$(echo "$response" | jq -r '.response.total')
    list=$(echo "$response" | jq -r '.response.list')

    formatted_projects=$(echo "$list" | jq -r '.[] | {name: .name, description: .description, avatar: .avatar, url: "https://thedapplist.com/project/\(.permalink)", timestamp: .timestamp, chains: [.chains[].name], categories: [.categories[].name], twitterHandle: .twitterHandle, website: .url}')
    projects+=("$formatted_projects")

    offset=$((offset + $(echo "$list" | jq -r 'length')))

    if [ $offset -ge $total ]; then
        break
    fi
done

echo "${projects[@]}" | jq -s '.' > project.json
echo "Output saved to project.json"