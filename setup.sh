BOLD='\e[1m'
GOLD='\e[38;5;226m'
GREY='\033[0;37m'
GREEN='\e[38;5;149m'
echo -e "${GREY}${BOLD}$(figlet -t -f slant Welcome to)" ; echo -e "${GOLD}${BOLD}$(figlet -t -f script Wordlist-Weaver!)"
echo -e "\033[0;37m\e[1m\t\t\t\t\t\t  ${GREY}${BOLD}© Created By: th3hack3rwiz\n"
echo -e "${GREEN}[+] Building gau"
GO111MODULE=on go get -u -v github.com/lc/gau > /dev/null 2>&1
git clone https://github.com/tomnomnom/hacks > /dev/null 2>&1
cd hacks/tok
echo -e "${GREEN}[+] Building tok"
go build
cp tok $(echo $GOPATH)/bin/tok 
cd ../unfurl
echo -e "${GREEN}[+] Building unfurl"
go build
cp unfurl $(echo $GOPATH)/bin/unfurl
echo -e "${GREEN}[+] Building anew"
go install -v github.com/tomnomnom/anew@latest
cd ../waybackurls
echo -e "${GREEN}[+] Building waybackurls"
go build
cp waybackurls $(echo $GOPATH)/bin/waybackurls
cd ../../
echo -e "${GREEN}[+] Preparing rfc-words\n"
curl https://tools.ietf.org/html/rfc1866 -o rfc.html > /dev/null 2>&1
cat rfc.html | tok | tr '[[:upper:]]' '[[:lower:]]' | sort -u > rfc-words
rm rfc.html
printf "\n"
test=$(pwd)/rfc-words
sed -i "s#XXXX#${test}#g" wordlistWeaver.sh
#echo -e "${GREY}[+] [IMPORTANT] Now add the above path ^ of rfc-words' to http://wordlistWeaver.sh: Line number -> 131"
echo -e "${GREEN}[+] You're all set!
