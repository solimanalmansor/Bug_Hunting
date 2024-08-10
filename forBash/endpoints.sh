#!/bin/bash

#
# output files discription:
# ${domain}_endpoints.txt: is the domain endpoints file
# potential_XSS.txt: is the endpoints which params maybe vulnrable to XSS
# potential_sqli.txt: is the endpoints which params maybe vulnrable to SQLi
# potential_LFI.txt: is the endpoints which params maybe vulnrable to LFI
#vpotential_openredirect.txt: is the endpoints which params maybe vulnrable to open redirect
# ${domain}_js_files: is the js files for the domain
# supposed to get only 6 files
#



# Check if a file was provided as an argument
if [ -z "$1" ]; then
    echo -e "\e[31mUsage: $0 <file containing a list of target sub-domain>\e[0m"
    exit 1
fi

# Set the file
domain="ffcuonline.us"
file="$1"

# Get all URLs from the domain using Katana
katana -u $file -c 10 --filter-regex '\.(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|otf|ttf)$' > ${domain}_endpoints.txt

# Get all URLs from the domain using gau
cat $file | gau | grep -E -v '\.(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|otf|ttf)$' >> ${domain}_endpoints.txt

# Get all URLs from the domain using hakrawler
cat $file | hakrawler | grep -E -v '\.(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|otf|ttf)$' >> ${domain}_endpoints.txt

# Get all URLs from the domain using waybackurls
cat $file | waybackurls | grep -E -v '\.(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|otf|ttf)$' >> ${domain}_endpoints.txt

# sorting and get unique the results in a text file
sort -u ${domain}_endpoints.txt | uro > F_${domain}_endpoints.txt
rm ${domain}_endpoints.txt && mv F_${domain}_endpoints.txt ${domain}_endpoints.txt

# trying GF patterns
cat ${domain}_endpoints.txt | gf xss > potential_XSS.txt
cat ${domain}_endpoints.txt | gf sqli > potential_sqli.txt
cat ${domain}_endpoints.txt | gf lfi > potential_LFI.txt
cat ${domain}_endpoints.txt | gf redirect > potential_openredirect.txt

# collecting JS files
cat ${domain}_endpoints.txt | grep ".js$" > ${domain}_js_files


