# Wordlist-Generator
The project aims at creating a target specific word-list for any Web Application that you are testing. 

# Requirements
- You must  download the rfc.html file first using the below commands
- $curl https://tools.ietf.org/html/rfc1866 -o rfc.html
- $cat rfc.html | tok | tr '[[:upper:]]' '[[:lower:]]' | sort -u > rfc-words
You must have the following tools installed 
- tok , anew (can be found in tomnomnom's hacks repository : https://github.com/tomnomnom/hacks )
- gau (https://github.com/lc/gau )

