GREEN='\e[38;5;149m'
GOLD='\e[38;5;226m'
GO111MODULE=on go get -u -v github.com/lc/gau
git clone https://github.com/tomnomnom/hacks 
cd hacks/tok
echo -e "${GREEN}[+] Building tok"
go build
cp tok $(echo $GOPATH)/bin/tok 
cd ../unfurl
echo -e "${GREEN}[+] Building unfurl"
go build
cp unfurl $(echo $GOPATH)/bin/unfurl
echo -e "${GREEN}[+] Building anew"
go get -u github.com/tomnomnom/anew
cd ../waybackurls
echo -e "${GREEN}[+] Building waybackurls"
go build
cp waybackurls $(echo $GOPATH)/bin/waybackurls
echo -e "${GREEN}[+] Installing gau"
cd ../../
curl https://tools.ietf.org/html/rfc1866 -o rfc.html
cat rfc.html | tok | tr '[[:upper:]]' '[[:lower:]]' | sort -u > rfc-words
rm rfc.html
printf "\n"
echo -e "${GOLD}$(pwd)/rfc-words"
echo -e "${GREEN}[+] Now add the above path ^ of rfc-words' to wordlistWeaver.sh: Line number -> 131"
