#!/bin/bash

# Check if a file was provided as an argument
if [ -z "$1" ]; then
    echo -e "\e[31mUsage: $0 <file.txt>\e[0m"
    exit 1
fi

# Set the file
file="$1"

