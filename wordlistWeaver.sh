#!/bin/bash
BOLD='\e[1m'
GOLD='\e[38;5;226m'
PINK='\e[38;5;204m'
ORANGE='\e[38;5;202m'
GREY='\033[0;37m'
OFFWHITE='\e[38;5;157m'
RED='\e[38;5;196m'
GREEN='\e[38;5;149m'
echo -e "${GOLD}${BOLD}$(figlet -t -f script Wordlist-Weaver)"
echo -e "\033[0;37m\e[1m\t\t\t\t\t\t  ${GREY}${BOLD}© Created By: th3hack3rwiz\n"

path="/"
function usage()
{
	echo -e "\n${PINK}[+] Usage:\n\t./wordlistWeaver.sh  <target-domain name>"
	echo -e " ${ORANGE}-p : ${GREEN}to specify a specific path of the target domain to grab generic words. (Default path:\"/\")" 
	echo -e " ${ORANGE}${BOLD}\n 	  Eg: ${GREEN}${BOLD}./wordlistWeaver.sh -p /some/specific/path/ example.com\n"
	echo -e "${ORANGE} -h : ${GREEN}to display usage."
	echo -e "${GREY}\n[+] IMPORTANT: Flags must be written before the target-domain name"
}	
while getopts :hp: opts; do
	case $opts in
		h)usage
		  exit 1
		  ;;
		p)path=$OPTARG
		  ;;
		*)echo -e "${RED}\nInvalid Argument! Check usage."
		  usage
		  exit 1
		  ;;
	esac
done
shift $((OPTIND-1))
if [[ $# -ne 1 ]] ; then
	usage
	exit 1
else
 	echo -e "${GOLD}\n[+] The wizards are weaving your target-specific wordlists! :))) \n"
 	echo -e "${GREY}[+] Gathering URLs of ${1}.....\n"
 	gau -subs ${1} | anew -q ${1}.urls
 	waybackurls ${1} | anew -q ${1}.urls
 	echo -e "${ORANGE}[+] Finding paths on ${1}....."
 	cat ${1}.urls | unfurl -u paths| sed 's#/#\n#g' | sort -u | grep ... | grep -Ev "%|\-\-|[[:lower:]]+-[[:lower:]]+-[[:lower:]]+|^[[:digit:]]+|^-|^_|^-[[:digit:]]|^[[:lower:]]+[[:upper:]]|.*,.*|[[:upper:]]+[[:lower:]]+[[:upper:]]+|_|[[:upper:]]+[[:digit:]]+|[[:lower:]]+[[:digit:]][[:digit:]]+[[:lower:]]*|[[:upper:]]+[[:digit:]][[:digit:]]+[[:lower:]]*|[[:alpha:]]+-[[:alpha:]]+-|^[[:digit:]]+|\.html$|==$|\.png$|\.jpg$|\.css$|\.gif$|\.pdf$|\.js$|\.jpeg$|\.tif$|\.tiff$|\.ttf$|\.woff$|\.woff2$|\.ico$|\.svg$|\.txt$" | anew -q ${1}.paths-wordlist.txt
 	echo -e "${GREEN}[+] $(cat ${1}.paths-wordlist.txt| wc -l) Paths obtained! :D"
 	echo -e "${ORANGE}\n[+] Finding parameters on ${1}....."
 	cat ${1}.urls | unfurl -u keys | anew -q ${1}.parameters-wordlist.txt
 	echo -e "${GREEN}[+] $(cat ${1}.parameters-wordlist.txt| wc -l) Parameters obtained! :D" 
 	printf "\n"
	echo -e "${ORANGE}[+] Finding generic words from: https://${1}${path} "
	wget https://${1}${path} --wait=3 -U "Mozilla/5.0 (X11; Linux i686 (x86_64)) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.75 Safari/537.36" --no-http-keep-alive --no-check-certificate --tries=1 -O ${1}.html &> /dev/null & sleep 8 ; 
	if [[ -s ${1}.html ]] ; then
		cat ${1}.html | tok | tr '[[:upper:]]' '[[:lower:]]' | grep -Ev "\-\-|[[:lower:]]+-[[:lower:]]+-[[:lower:]]+|^[[:digit:]]+|^-|^_|^-[[:digit:]]|^x|^[[:lower:]]+[[:upper:]]|[[:upper:]]+[[:lower:]]+[[:upper:]]+|_|[[:upper:]]+[[:digit:]]+|[[:lower:]]+[[:digit:]]+[[:lower:]]*|[[:upper:]]+[[:digit:]][[:digit:]]+[[:lower:]]*|[[:alpha:]]+-[[:alpha:]]+-|^[[:digit:]]+" | grep .. | sort -u  | anew -q ${1}-words 
		#comm -13 <path_to_rfc_words>/rfc-words ${1}-words | anew -q ${1}.generic-wordlist.txt
		echo -e "${GREEN}[+] $(cat ${1}.generic-wordlist.txt | wc -l) Generic-words generated! :D"
		cat ${1}.generic-wordlist.txt | anew -q ${1}.paths-wordlist.txt
		rm ${1}-words 
		rm ${1}.html
	else
		echo -e "${RED}[-] The specified path could not be fetched from the domain. Please try again. :("
		disown
		killall -9 wget &> /dev/null
		rm ${1}.html
	fi
	echo -e "${GOLD}\n[+] Thank you for using Wordlist-Weaver! :D"
fi
