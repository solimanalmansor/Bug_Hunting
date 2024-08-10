#!/bin/bash

if [ -z "$1" ]; then
	echo "usage: $0 <url> [wordlist]"
	exit 1
fi

if [ -n "$2" ]; then
	ffuf -u "$1"FUZZ -w "$2" -c -ac
else
	ffuf -u "$1"FUZZ -w ~/wordlists/dirsearch_list.txt -c -ac
fi
