#!/bin/bash

# Check if a file was provided as an argument
if [ -z "$1" ]; then
    echo -e "\e[31mUsage: $0 <file.txt>\e[0m"
    exit 1
fi

# Set the file
file="$1"

# Read each line from the file, replace the URL parameter value with "evil.com",
# and check if the response contains "evil.com"
while read -r line; do
    url=$(echo "$line" | cut -d '=' -f 2)
    curl_output=$(curl -s -L "$(echo "$url" | qsreplace "evil.com")" -I)
    if echo "$curl_output" | grep -q "evil.com"; then
        echo -e "\e[31mVulnerable URL:\e[0m $url"
    fi
done < "$file"