#!/bin/bash
BOLD='\e[1m'
GOLD='\e[38;5;226m'
PINK='\e[38;5;204m'
ORANGE='\e[38;5;202m'
GREY='\033[0;37m'
OFFWHITE='\e[38;5;157m'
RED='\e[38;5;196m'
GREEN='\e[38;5;149m'
CYAN='\033[0;36m'
echo -e "${GOLD}${BOLD}$(figlet -t -f script Wordlist-Weaver)"
echo -e "\033[0;37m\e[1m\t\t\t\t\t\t  ${GREY}${BOLD}© Created By: th3hack3rwiz\n"

path="/"
urlflag=0 	#flag to input user list
subflag=0   #flag to input subdomain-list
pflag=0 	#flag to input paths-list
function usage()
{
	echo -e "\n${PINK}[+] Usage:\n\t./wordlistWeaver.sh  <target-domain name>"
	echo -e " ${ORANGE}-p : ${GREY}to specify a specific path of the target domain OR a URL (path) of the target domain/subdomain to grab generic words. (Default path:\"/\")" 
	echo -e " ${ORANGE}${BOLD}\n 	  Eg: ${GREEN}${BOLD}./wordlistWeaver.sh -p /some/specific/path/ example.com -> will fetch words from https://example.com/some/specific/path/"
	echo -e " ${ORANGE}${BOLD} 	  Eg: ${GREEN}${BOLD}./wordlistWeaver.sh -p https://xyz.example.com/some/path/on/xyz example.com -> will fetch words from that subdomain URL\n"
	echo -e " ${ORANGE}-P : ${GREY}to specify a list of paths (URLs) of the target domain/sub-domain to grab generic-words. (Default path:\"/\" i.e https://target-domain/)" 
	echo -e " ${ORANGE}${BOLD}\n 	  Eg: ${GREEN}${BOLD}./wordlistWeaver.sh -P example.com_paths.txt example.com\n"
	echo -e "${ORANGE} -U : ${GREY}to specify a file containing URLs of the target to avoid fetching them."
	echo -e " ${ORANGE}${BOLD}\n 	  Eg: ${GREEN}${BOLD}./wordlistWeaver.sh -U example.com_urls.txt -p /some/specific/path/ example.com\n"
	echo -e "${ORANGE} -S : ${GREY}to specify a file containing subdomains of the target to fetch their URLs explicitely."
	echo -e " ${ORANGE}${BOLD}\n 	  Eg: ${GREEN}${BOLD}./wordlistWeaver.sh -S example.com_subdomains.txt -p /some/specific/path/ example.com\n"
	echo -e "${ORANGE} -h : ${GREY}to display usage."
	echo -e "${OFFWHITE}\n[+] IMPORTANT: Flags must be written before the target-domain name"
}	
while getopts :hp:U:S:P: opts; do
	case $opts in
		P)pflag=1
		  pathfile=$OPTARG
		  ;;
		S)subflag=1
		  subfile=$OPTARG
		  ;;
		U)urlflag=1
		  urlfile=$OPTARG
		  ;;
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
 	if [[ $urlflag -eq 1 && $subflag -eq 0 ]] ; then
 		cat $urlfile | anew -q ${1}.urls
 	elif [[ $subflag -eq 1 && $urlflag -eq 0 ]] ; then
 		echo -e "${GREY}[+] Gathering URLs for *.${1}"
	 	gau -subs ${1} | anew -q ${1}.urls & waybackurls ${1} | anew -q ${1}.urls
	 	wait
 		for line in $(cat $subfile) ; do
			echo -e "${GREY}[+] Gathering URLs for $line..."
			waybackurls $line | anew -q ${1}.urls & gau $line | anew -q ${1}.urls
			wait
		done
		cat ${1}.urls | sort -u > buff ; cat buff > ${1}.urls ; rm buff;
		printf "\n"
 	elif [[ $urlflag -eq 1 && $subflag -eq 1 ]] ; then
 		cat $urlfile | anew -q ${1}.urls
 		echo -e "${GREY}[+] Gathering URLs for *.${1}"
	 	gau -subs ${1} | anew -q ${1}.urls & waybackurls ${1} | anew -q ${1}.urls
	 	wait
 		for line in $(cat $subfile) ; do
			echo -e "${GREY}[+] Gathering URLs for $line..."
			waybackurls $line | anew -q ${1}.urls & gau $line | anew -q ${1}.urls
			wait
		done
		cat ${1}.urls | sort -u > buff ; cat buff > ${1}.urls ; rm buff;
		printf "\n"
 	else
	 	echo -e "${GREY}[+] Gathering URLs of ${1}\n"
	 	gau -subs ${1} | anew -q ${1}.urls & waybackurls ${1} | anew -q ${1}.urls
	 	wait
	 	cat ${1}.urls | sort -u > buff ; cat buff > ${1}.urls ; rm buff;
	fi
 	echo -e "${ORANGE}[+] Finding paths on ${1}....."
 	cat ${1}.urls | unfurl -u paths| sed 's#/#\n#g' | sort -u | grep ... | grep -Ev "%|\-\-|[[:lower:]]+-[[:lower:]]+-[[:lower:]]+|^[[:digit:]]+|^-|^_|^-[[:digit:]]|^[[:lower:]]+[[:upper:]]|.*,.*|[[:upper:]]+[[:lower:]]+[[:upper:]]+|_|[[:upper:]]+[[:digit:]]+|[[:lower:]]+[[:digit:]][[:digit:]]+[[:lower:]]*|[[:upper:]]+[[:digit:]][[:digit:]]+[[:lower:]]*|[[:alpha:]]+-[[:alpha:]]+-|^[[:digit:]]+|\.html$|==$|\.png$|\.jpg$|\.css$|\.gif$|\.pdf$|\.js$|\.jpeg$|\.tif$|\.tiff$|\.ttf$|\.woff$|\.woff2$|\.ico$|\.svg$|\.txt$" | anew -q ${1}.paths-wordlist.txt
 	echo -e "${GREEN}[+] $(cat ${1}.paths-wordlist.txt| wc -l) Paths obtained! :D"
 	echo -e "${ORANGE}\n[+] Finding parameters on ${1}....."
 	cat ${1}.urls | unfurl -u keys | anew -q ${1}.parameters-wordlist.txt
 	echo -e "${GREEN}[+] $(cat ${1}.parameters-wordlist.txt| wc -l) Parameters obtained! :D" 
 	printf "\n"
	if [[ $pflag -eq 1 ]] ; then
		for line in $(cat $pathfile) ; 
		do
			echo -e "${ORANGE}[+] Fetching generic words from: $line "
			wget $line --wait=3 -U "Mozilla/5.0 (X11; Linux i686 (x86_64)) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.75 Safari/537.36" --no-http-keep-alive --no-check-certificate --tries=1 -O ${1}.html &> /dev/null & sleep 7 ; 
			cat ${1}.html >> fetched_paths
		done
		cat fetched_paths > ${1}.html ; rm fetched_paths
	else
		echo $path | grep ${1} | grep http > /dev/null
		if [[ $? -eq 0 ]] ; then
			echo -e "${ORANGE}[+] Fetching generic words from: ${path} "
			wget ${path} --wait=3 -U "Mozilla/5.0 (X11; Linux i686 (x86_64)) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.75 Safari/537.36" --no-http-keep-alive --no-check-certificate --tries=1 -O ${1}.html &> /dev/null & sleep 7 ; 
		else
			echo -e "${ORANGE}[+] Fetching generic words from: https://${1}${path} "
			wget https://${1}${path} --wait=3 -U "Mozilla/5.0 (X11; Linux i686 (x86_64)) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.75 Safari/537.36" --no-http-keep-alive --no-check-certificate --tries=1 -O ${1}.html &> /dev/null & sleep 8 ; 
		fi
	fi
	if [[ -s ${1}.html ]] ; then
		cat ${1}.html | tok | tr '[[:upper:]]' '[[:lower:]]' | grep -Ev "\-\-|[[:lower:]]+-[[:lower:]]+-[[:lower:]]+|^[[:digit:]]+|^-|^_|^-[[:digit:]]|^x|^[[:lower:]]+[[:upper:]]|[[:upper:]]+[[:lower:]]+[[:upper:]]+|_|[[:upper:]]+[[:digit:]]+|[[:lower:]]+[[:digit:]]+[[:lower:]]*|[[:upper:]]+[[:digit:]][[:digit:]]+[[:lower:]]*|[[:alpha:]]+-[[:alpha:]]+-|^[[:digit:]]+" | grep .. | sort -u  | anew -q ${1}-words 
		comm -13 /home/hack3rwiz/Downloads/hacks/rfc-words ${1}-words | anew -q ${1}.generic-wordlist.txt
		echo -e "${GREEN}[+] $(cat ${1}.generic-wordlist.txt | wc -l) Generic-words generated! :D"
		cat ${1}.generic-wordlist.txt | anew -q ${1}.paths-wordlist.txt
		rm ${1}-words 
		rm ${1}.html
	else
		echo $path | grep ${1} | grep http > /dev/null
		if [[ $? -eq 0 ]] ; then
			echo -e "${RED}[-] The specified path: ${path} could not be fetched. Please try with a different path or try again. :("
			disown
			killall -9 wget &> /dev/null
			rm ${1}.html
		else
			echo -e "${RED}[-] The specified path: https://${1}${path} could not be fetched. Please try with a different path or try again. :("
			disown
			killall -9 wget &> /dev/null
			rm ${1}.html
		fi
	fi
	echo -e "${GOLD}\n[+] Thank you for using Wordlist-Weaver! :D"
fi
