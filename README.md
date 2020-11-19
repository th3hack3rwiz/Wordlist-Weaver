![](https://th3hack3rwiz.github.io/images/Wordlist-Weaver/banner.PNG)
## Wordlist-Weaver

This project aims at crafting a target-specific wordlists. 

## Installation

1. Clone the repository :  git clone https://github.com/th3hack3rwiz/Wordlist-Weaver.git
2. cd Wordlist-Weaver ; chmod +x wordlistWeaver.sh 

## Requirements

- You must first download the rfc.html file and then obtain rfc-words using the below commands
- $curl https://tools.ietf.org/html/rfc1866 -o rfc.html
- $cat rfc.html | tok | tr '[[:upper:]]' '[[:lower:]]' | sort -u > rfc-words 
- You must have the following tools installed: >
  - tok: https://github.com/tomnomnom/hacks/tree/master/tok
  - unfurl: https://github.com/tomnomnom/unfurl
  - anew: https://github.com/tomnomnom/anew
  - gau: https://github.com/lc/gau
  - waybackurls: https://github.com/tomnomnom/waybackurls

## Instructions

1. Install all the tools and make sure all of them are ready to use from the terminal. 
2. Once rfc-words file is ready, add it’s path to line No. 55 of wordlistWeaver.sh
3. wordlistWeaver.sh is now ready to use!

## Usage

- It requires only one command line argument which is the target-domain name. 

  Simple usage: 	./wordlistWeaver.sh   <target_domain>

![](https://th3hack3rwiz.github.io/images/Wordlist-Weaver/usage.PNG)

## Sample Usage

![](https://th3hack3rwiz.github.io/images/Wordlist-Weaver/result.PNG)

## Explained Output

![](https://th3hack3rwiz.github.io/images/Wordlist-Weaver/explained_output.PNG)

## Features

- It creates 3 target-specific wordlists:
  - Generic wordlist: Generic words used on https://parent-domain/path
  - Parameter wordlist: Parameters found from the URLs gathered.
  - Path wordlist: Paths found from the URLs gathered.
- These wordlists can be used for content-discovery, finding sensitive endpoints, vulnerable parameters, etcetera. 
