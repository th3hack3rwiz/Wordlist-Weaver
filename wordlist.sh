#!/bin/bash

read -p "Enter parent domain name: " pdomain
path="/"
read -p "Enter any known path of parent domain from where you want to skim words, or press enter for default (/)..." path
echo "[+]Finding paths on ${pdomain}....."
gau -subs ${pdomain} > ${pdomain}.urls
cat ${pdomain}.urls | unfurl -u paths | sed 's#/#\n#g' | sort -u | grep -v [[:digit:]] > ${pdomain}.paths
echo "[+]Finding parameters on ${pdomain}....."
cat ${pdomain}.urls | unfurl -u keys | sed 's#/#\n#g' | sort -u | grep -v [[:digit:]] > ${pdomain}.parameters 
echo "[+] Optimizing Results!"
printf "\n"
cat ${pdomain}.paths | grep -Ev "\.html$|==$|\.png$|\.jpg$|\.css$|\.gif$|\.pdf$|\.js$|\.jpeg$|\.tif$|\.tiff$|\.ttf$|\.woff$|\.woff2$|\.ico$|\.svg$|\.txt$" | sort -u > paths ; cat paths > ${pdomain}.paths ; rm paths
echo "[+] Finding generic words..."
wget https://${pdomain}/${path} --no-check-certificate -O ${pdomain}.html
cat ${pdomain}.html | tok | tr '[[:upper:]]' '[[:lower:]]' | sort -u  | anew ${pdomain}.words 
comm -13 <path to rfc-words>/rfc-words ${pdomain}.words > ${pdomain}.generic-words
echo "[-] Done!"
