#!/bin/bash

# Print the stylized text banner in red
echo -e "\033[1;31m"
figlet -f slant "RECON"
echo -e "\033[0m"


# getting the target domain

# Check if a domain was provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

# Set the domain
domain="$1"


echo -e "\n"

# making dir for recon results
pathto=recon/${domain}_recon
mkdir $pathto

# Subfinder
echo -e "\e[1;34m[!] Running Subfinder...\e[0m"
subfinder -d $domain -all -silent -o $pathto/SubfinderFor_${domain}.txt
sbf_count=$(cat $pathto/SubfinderFor_${domain}.txt | wc -l)
echo -e "\e[32m[+] $sbf_count Subdomains Has Been Found By Subfinder\e[0m"
echo -e "\n"

# assetfinder
assetfinder --subs-only $domain | tee $pathto/AssetfinderFor_${domain}.txt
aset_count=$(cat $pathto/AssetfinderFor_${domain}.txt | wc -l)
echo -e "\e[32m[+] $aset_count Subdomains Has Been Found By Assetfinder\e[0m"
echo -e "\n"


# shosubgo
echo -e "\e[1;34m[!] Running shosubgo...\e[0m"
shosubgo -d $domain -s wrNdh9QSc5sKC3Za0m8TfUyffbq0Hk23 | tee $pathto/ShosubgoFor_${domain}.txt
shsg_count=$(cat $pathto/ShosubgoFor_${domain}.txt | wc -l)
echo -e "\e[32m[+] $shsg_count subdomains has been found by shosubgo\e[0m"
echo -e "\n"

# bbot 
echo -e "\e[1;34m[!] Running BBOT...\e[0m"
nohup bbot -t $domain -f subdomain-enum -o $pathto/bbot_results > /dev/null 2>&1 &
bbot_pid=$!
wait $bbot_pid
cat $pathto/bbot_results/*/subdomains.txt
bbot_count=$(cat $pathto/bbot_results/*/subdomains.txt | wc -l)
echo -e "\e[32m[+] $bbot_count Subdomains Has Been Found By BBOT\e[0m"
echo -e "\n"

# Amass
# echo -e "\e[1;34m[!] Running Amass...\e[0m"
# amass enum -d $domain --passive -silent -nocolor -o $pathto/SOME_AmassFor_${domain}.txt
# grep -oP '([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})' $pathto/SOME_AmassFor_${domain}.txt | sort -u > $pathto/AmassFor_${domain}.txt
# $amass_count=$(cat $pathto/AmassFor_${domain}.txt | wc -l)
# echo -e "\e[32m[+] $amass_count Subdomains Has Been Found By amass\e[0m"
# echo -e "\n"

# crt.sh
echo -e "\e[1;34m[!] Running crt.sh...\e[0m"
curl --silent "https://crt.sh/?q=$domain&output=json" -o $pathto/SOMEcrtshFor_${domain} 
jq -r ".[] | .name_value" $pathto/SOMEcrtshFor_${domain} > $pathto/crtshFor_${domain}.txt
rm -rf $pathto/SOMEcrtshFor_${domain}
cat $pathto/crtshFor_${domain}.txt
crt_count=$(cat $pathto/crtshFor_${domain}.txt | wc -l)
echo -e "\e[32m[+] $crt_count Subdomains Has Been Found By crt.sh\e[0m"
echo -e "\n"


# cloud recon
: '
    code here
'


# github-subdomains
echo -e "\e[1;34m[!] Running github-subdomains...\e[0m"
github-subdomains -d $domain -t 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 -o $pathto/GHSBD_For_${domain}.txt
GHSBD_count=$(cat $pathto/GHSBD_For_${domain}.txt | wc -l)
echo -e "\e[32m[+] $GHSBD_count Subdomains Has Been Found By github-subdomains\e[0m"
echo -e "\n"


# exstra subs

: '
while true; do
    echo -e "\e[1;31m[?] Do you want to provide exstra subdomains? (Y/N)\e[0m"
    read answer
    case "$answer" in
        [Yy])
            # Prompt the user for input
            echo "Enter the value (press Ctrl+D to finish):"
            # Use 'Ctrl+D' to signal end-of-input
            value=$(cat)

            # Check if the user provided any input
            if [ -n "$value" ]; then
                echo $value > $pathto/exstraSubsFor_${domain}.txt

            else
                echo "No input provided. Exiting."
            fi
            ;;
        [Nn])
            break  # Exit the loop when the user chooses "No"
            ;;
        *)
            echo "Invalid input. Please enter Y or N."
            ;;
    esac
done
'

# sorting
echo -e "\e[1;34m[+] Combining the Results...\e[0m"
cat $pathto/SubfinderFor_${domain}.txt $pathto/AssetfinderFor_${domain}.txt $pathto/ShosubgoFor_${domain}.txt $pathto/bbot_results/*/subdomains.txt $pathto/AmassFor_${domain}.txt $pathto/crtshFor_${domain}.txt $pathto/GHSBD_For_${domain}.txt | sort | uniq > $pathto/allSubdomainsFor_${domain}.txt
allCount=$(cat $pathto/allSubdomainsFor_${domain}.txt | wc -l )
echo -e "\e[32m[+] $allCount Subdomains Has Been Found\e[0m"
echo -e "\n"

# HTTPX
echo -e "\e[1;34m[!] Running HTTPX...\e[0m"
httpx -l $pathto/allSubdomainsFor_${domain}.txt -o $pathto/Final_results_for_${domain}.txt
echo -e "\e[32m[+] results have been stored in $pathto\e[0m"
echo -e "\n"

# deleting unwanted files 
rm $pathto/SubfinderFor_${domain}.txt
rm $pathto/AssetfinderFor_${domain}.txt
rm $pathto/ShosubgoFor_${domain}.txt
rm -rf $pathto/bbot_results
rm $pathto/SOME_AmassFor_${domain}.txt
rm $pathto/AmassFor_${domain}.txt
rm $pathto/crtshFor_${domain}.txt
rm $pathto/GHSBD_For_${domain}.txt



date=$(date)
echo "This Recon Was Created on $date"