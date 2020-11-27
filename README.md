![](https://th3hack3rwiz.github.io/images/Wordlist-Weaver/banner.PNG)
## Wordlist-Weaver

This project aims at crafting target-specific wordlists. 

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
2. Once rfc-words file is ready, add it’s path to line No. 119 of wordlistWeaver.sh!
3. wordlistWeaver.sh is now ready to use!

## Usage

- It requires only one command line argument which is the target-domain name. 

  Simple usage: 	./wordlistWeaver.sh   <target_domain>

![](https://th3hack3rwiz.github.io/images/Wordlist-Weaver/usage.PNG)

## Sample Usage

##### Different Usage Scenarios:

1. In the following example, Wordlist-Weaver gathers the URLs of the target and generates paths, parameters and, generic-words wordlists.

![](https://th3hack3rwiz.github.io/images/Wordlist-Weaver/default_use.PNG)

2. If you have a list of URLs gathered (from your Burp Suite / other tools) and want to use that file to skip gathering URLs and to craft paths and parameters wordlists, you can use “-U” flag followed by the file containing the URLs of the target domain/sub-domain.

![](https://th3hack3rwiz.github.io/images/Wordlist-Weaver/-U.PNG)

3. If you want to fetch the generic-words from a path on the target domain itself. You can use “-p” flag for the same, followed by the relative path. 
    Eg: To fetch generic-words from https://target-domain.com/home we can do:

![](https://th3hack3rwiz.github.io/images/Wordlist-Weaver/-p1.PNG)

4. If you want to generate the generic-words from some specific path of the target domain/sub-domain, you can use the “-p” flag followed by the URL of your desired path on the target domain/sub-domain. 

![](https://th3hack3rwiz.github.io/images/Wordlist-Weaver/-p2.PNG)

5. If you want to fetch the generic-words from multiple juicy paths (URLs) of your target’s domain/sub-domains. You can use the “-P” flag followed by the file containing the list of path URLs.

​       For Eg: If I want to fetch the generic words from the following list of paths (URLs):

![](https://th3hack3rwiz.github.io/images/Wordlist-Weaver/paths.PNG)

![](https://th3hack3rwiz.github.io/images/Wordlist-Weaver/-P.PNG)

6. If you wish to explicitly gather the URLs of the sub-domains that you have discovered of your target, then you can use the “-S” flag followed by the file containing a list of sub-domains.

   Eg: If I want to gather the URLs of the following subdomains:

![](https://th3hack3rwiz.github.io/images/Wordlist-Weaver/subdomains.PNG)

![](https://th3hack3rwiz.github.io/images/Wordlist-Weaver/-S.PNG)

## Explained Output

![](https://th3hack3rwiz.github.io/images/Wordlist-Weaver/explained_output.PNG)

## Features

- It creates 3 target-specific wordlists:
  - Generic wordlist: Generic words used on https://parent-domain/path
  - Parameter wordlist: Parameters found from the URLs gathered.
  - Path wordlist: Paths found from the URLs gathered.
- These wordlists can be used for content-discovery, finding sensitive endpoints, vulnerable parameters, etcetera. 
