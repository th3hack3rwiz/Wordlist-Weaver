#!/bin/bash

read -p "Enter parent domain name: " pdomain
path="/"
read -p "Enter any known path(without initial '/'), or press enter..." path
echo "[+]Finding paths on ${pdomain}....."
cat ${pdomain}.waybackurls | unfurl -u paths| sed 's#/#\n#g' | sort -u > ${pdomain}.paths
echo "[+]Finding parameters on ${pdomain}....."
cat ${pdomain}.waybackurls | unfurl -u keys > ${pdomain}.parameters 
echo "[+] Optimizing Results!"
printf "\n"
cat ${pdomain}.paths | grep -Ev "\.html$|==$|\.png$|\.jpg$|\.css$|\.gif$|\.pdf$|\.js$|\.jpeg$|\.tif$|\.tiff$|\.ttf$|\.woff$|\.woff2$|\.ico$|\.svg$|\.txt$" | sort -u > paths ; cat paths > ${pdomain}.paths ; rm paths
cat ${pdomain}.parameters | sort -u > params ; cat params > ${pdomain}.parameters ; rm params
echo "[+] Finding generic words..."
wget https://${pdomain}/${path} --no-check-certificate -O ${pdomain}.html
cat ${pdomain}.html | /home/hack3rwiz/Downloads/hacks/tok/./tok | tr '[[:upper:]]' '[[:lower:]]' | sort -u  | anew ${pdomain}-words 
comm -13 /home/hack3rwiz/Downloads/hacks/rfc-words ${pdomain}-words > ${pdomain}.generic-words
echo "[-] Done!"