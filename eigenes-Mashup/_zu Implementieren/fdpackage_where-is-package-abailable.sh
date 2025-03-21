#!/bin/bash
#!/bin/bash -e
#
# 11.03.2025 - Closer2U
#
# Script to check if a given app/tool/package is already installed  
# and if not it gives options where to find it
# The following package "managers" are queried:
#        nala (apt), 
#	 snap, flatpak, 
#	 am (appimages), 
#	 pacstall (AUR like for Ubuntu)
# TODO: Add pip/python support
# TODO: fix flatpak always saying available --> if really is there is more output

BoldYellow='\033[1;33m'
Red='\e[31m'
BoldGreen="\e[0;92m"
NoColour='\033[0m'

## Parameter specified?
if [ $# -eq 0 ]; then
    echo -e "No package specified"
  exit 1
fi

## Logic

package="$2"
echo "${2} -s QUERY is missing. See -h" 

function check_availability(){
	printf "${BoldYellow}\nAPT\n${NoColour}"
	dpkg -l | grep ${package} && printf "  👍 Already installed. " || printf "  ${Red}✘${NoColour} Not installed. "
		
	printf "${BoldYellow}\nNALA\n${NoColour}"
	nala list -i | grep ${package} && printf "  👍 Already installed. " || printf "  ${Red}✘${NoColour} Not installed. "
	nala search ${package} && printf "  ${BoldGreen}✔${NoColour} is available!" || printf "  ${Red}✘${NoColour} Not available. "

	printf "${BoldYellow}\nFLATPAK\n${NoColour}"
	flatpak list | grep ${package} && printf "  👍 Already installed. " || printf "  ${Red}✘${NoColour} Not installed. "
	flatpak search ${package} && printf "  ${BoldGreen}✔${NoColour} is available!" || printf "  ${Red}✘${NoColour} Not available. "

	printf "${BoldYellow}\nSNAP\n${NoColour}"
	snap list | grep ${package} && printf "  👍 Already installed.\n " || printf "  ${Red}✘${NoColour} Not installed.\n"
	snap search ${package} | grep ${package} && printf "  ${BoldGreen}✔${NoColour} is available!" || printf "  ${Red}✘${NoColour} Not available. "
	
	printf "${BoldYellow}\nAPP-MANAGER (AM)\n${NoColour}"
	am -f --byname q| grep ${package} && printf "  👍 Already installed. " || printf "  ${Red}✘${NoColour} Not installed. "
	am -q --all ${package} | grep ${package} && printf "  ${BoldGreen}✔${NoColour} is available?" || printf "\n  ${Red}✘${NoColour} Not available. "
		
	printf "${BoldYellow}\nPACSTALL\n${NoColour}"
	pacstall -L | grep ${package} && printf "  👍 Already installed. " || printf "  ${Red}✘${NoColour} Not installed. "
	pacstall -Sd ${package} && printf "  ${BoldGreen}✔${NoColour} is available!" || printf "  ${Red}✘${NoColour} Not available. "
}

## Hilfe
OPTSTRING="hs:"

while getopts ${OPTSTRING} opt; do
  case ${opt} in
    h)
      printf "Option -h was triggered."
      printf ""
      printf "-------------------------------------------------------------------------------------------------------"
      printf "Usage: ./is-package-available.sh -s firefox  # is firefox installed or available by any package manager"
      printf ""
      ;;
    s) check_availability 
      ;;
    ?)
      printf "Invalid option: -${OPTARG}."
      exit 1
      ;;
  esac
done




```
