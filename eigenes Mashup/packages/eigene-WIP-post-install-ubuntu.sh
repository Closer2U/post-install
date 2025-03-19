#!/bin/bash

green='\e[32m' 			    # Coloured echo (Green)
yellow=$'\033[38;5;11m' 	# Coloured echo (yellow)
red=$'\033[0;31m'		    # Coloured echo (red)
r='tput sgr0' 		     	# Reset colour after echo

[[ -d ${HOME}/Apps/Tools ]] || mkdir -p ${HOME}/Apps/Tools

# ==================================================
#       Package Management
# ==================================================
# homebrew			- install packages w/o sudo
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# pacstall 			- AUR (deb) like package manager. But for Ubuntu/Debian (only)! Handles 
## Determine the distro
function get_distro() {
    if [[ -f /etc/os-release ]]
    then
        # On Linux systems
        source /etc/os-release
        echo $ID_LIKE
    else
        # On systems other than Linux (e.g. Mac or FreeBSD)
        uname
    fi
}
if get_distro | grep -q 'ubuntu\|debian'; then sudo bash -c "$(curl -fsSL https://pacstall.dev/q/install || wget -q https://pacstall.dev/q/install -O -)" && echo -e "${green}Paketmanager >>>Pacstall<<< wurde installiert."; $r; else echo -e "${red}Kann pacstall nicht verwenden. System nicht Ubuntubasiert."; $r; fi

# nala 					- Prettier apt frontend
pacstall -I nala-deb
echo -e "${green}Paketmanager >>>nala<<<  wurde installiert."; $r;

# appmanager (am)		- make AppImages of almost every package
wget -q https://raw.githubusercontent.com/ivan-hc/AM/main/AM-INSTALLER && chmod a+x ./AM-INSTALLER && ./AM-INSTALLER
echo -e "${green}Paketmanager >>>appmanager (AM)<<<  wurde installiert."; $r;

# init snap und flatpak		- applications packaged with all their dependencies 
sudo nala install flatpak
sudo nala install gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.github.tchx84.Flatseal
echo -e "${green}Paketmanager >>>flatpak<<< und Berechtigungsmanager >>>flatseal<<< wurden installiert."; $r;

#sudo nala install snapd
#echo -e "${green}Paketmanager >>>snap<<<  wurde installiert."; $r;

# eget				- easily install Binaries from github repos
cd ${HOME}/Apps/Tools
mkdir [[ -d eget ]] || mkdir eget && cd "$_"
curl https://zyedidia.github.io/eget.sh | sh

# ==================================================
#       cli
# ==================================================
############################
# everything with FILES
# 
#fd				- find utility that is easy to use and allows filtering for eg extension or to execute unzip !!! can be used with batcat! fd … -X bat
sudo nala install fd-find
echo 'PATH="$HOME/bin:$HOME/.local/bin:$PATH"' >> ${HOME}/.profile
ln -s $(which fdfind) ~/.local/bin/fd

# batcat
# jq 

#linutil            - automate stuff like user settings, updates etc. System agnostic

# grex 				- create regex from userinput
#cd ${HOME}/Apps/Tools
#eget pemistahl/grex
#echo -e "${green}Automatic Regex Builder >>>grex<<< wurde installiert."; $r;

#pgrep
## autosuggestion
## autocompletion
#which
#7z

############################
# TERMINAL APPS
#

# MY SCRIPT TO CHECK IF PACKAGE IS INSTALLED AND/OR AVAILABLE ANYWHERE
curl -s --insecure --output is-package-available.sh "https://gist.github.com/Closer2U/82ef36afa351fd0ef0fff5cfce32afea/raw/320ab4db48ccc0d929c0b3b54da634026499fa09/is-package-available.sh"
chmod +x is-package-available.sh

# micro - better than nano
eget zyedidia/micro
sudo mv micro /usr/local/bin
echo " ODER: curl https://getmic.ro | bash"

# wttr.in
# cht.sh 
sudo nala install rlwrap
curl -s https://cht.sh/:cht.sh | sudo tee /usr/local/bin/cht.sh && sudo chmod +x /usr/local/bin/cht.sh

# howdoi			- instant coding answers. Needs VPN outside EU
python3 -m venv venv-howdoi && source venv-howdoi/bin/activate 
pip3 install howdoi       # Programm ist nur bei aktiver virtueller Umgebung nutzbar  


sudo nala install curl wget xclip


############################
# no need to remember
#

# cheat.sh --user

# thefuck --user


############################
# SYSTEM MONITORING
#
# bashtop/bpytop/btop
eget aristocratos/btop

############################
# LOOKS and FEEL (shell)
#
# make Terminal look like kalis. Siehe tutorial 

#ohmyzsh + nerdfont

# this tool that adjusts terminal colors to background image

# tmux
## firacode 

# ==================================================
#       Coding and Development
# ==================================================
# VSCode --user

############################
# PYTHON
# 
## poetry/pyenv

############################
# GO
# 

############################
# VIRTUALISIERUNG
# 
# Podman 			- GUI for working with Containerfiles, like Docker. Needed for Distrobox
echo -e "${green}VMWare Workstation successfully installed."; $r
flatpak install flathub io.podman_desktop.PodmanDesktop

# distrobox
### without sudo
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --prefix ~/.local

# VMware 			- free licence professional "VirtualBox"
#[[ -d ${HOME}/Apps ]] || mkdir ${HOME}Apps
echo -e "${y}Downloading and extracting VMWare Workstation."; $r
mkdir -p ${HOME}/Apps && cd ${HOME}/Apps && curl -L -s https://softwareupdate.vmware.com/cds/vmw-desktop/ws/17.6.1/24319023/linux/core/VMware-Workstation-17.6.1-24319023.x86_64.bundle.tar | tar -zx -C ${HOME}/Apps/
sudo chmod +x VMware-Workstation-*.x86_64.bundle
sudo nala update
sudo nala install gcc-12 libgcc-12-dev build-essential -y
sudo ./${ls | grep VMWare*.bundle}
echo -e "${green}VMWare Workstation successfully installed."; $r

# gnomeboxes

# ==================================================
#       git
# ==================================================

# ==================================================
#       security
# ==================================================

# ufw

# Proton VPN flatpak
flatpak install flathub com.protonvpn.www

# ==================================================
#       Personal Utilities
# ==================================================
############################
# TEXT
# 
# Joplin
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash

############################
# INTERNET
# 
# raindrop.io


# ==================================================
#       GUI Apps
# ==================================================
############################
# SYSTEM MONITOR
# 
# stacer					- THE System Monitoring Tool
##curl -s ${curl -s https://api.github.com/repos/oguzhaninan/Stacer/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep "*.AppImage"}
am -i stacer


# S3Drive Client for Koofr and such
sudo nala install rclone
flatpak install flathub io.kapsa.drive


# ==================================================
#       ALIAS bzw. .bashrc/.zshrc
# ==================================================
#WIP
cp ${HOME}/.bashrc {HOME}/.bashrc_backup
[[ -f ${HOME}/.zshrc ]] || cp ${HOME}/.zshrc ${HOME}/.zshrc_backup
echo -e "${c}Richte .bashrc ein."; $r

cat <<EOT >> .bashrc
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
EOT

[[ -f ${HOME}/.zshrc ]] || cat <<EOT >> .zshrc
if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
fi
EOT

cat <<EOT >> .bashrc_alias
#######################
## PACKAGE MANAGEMENT
## aliases for install and update + add updates separately for eg zsh, pip3 list --outdated --format=freeze | grep [...]

alias update="sudo nala update -y && sudo nala upgrade -y && sudo nala autoremove -y && snap refresh && flatpak update -y && pacstall -U && pacstall -Up && am -u && wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash && am -f && pacstall -L && snap list && flatpak list" 

#######################
## PROCESS MANAGEMENT
# easier Process identification
alias psaux="ps aux | grep"
alias hg="history | grep "

##xclip alias dieses ewig lange sel command

#######################
## Program shorthands
alias cht="cht.sh"
alias cat="batcat"

EOT

cat <<EOT >> .zshrc_alias

# colorized help messages via bat
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

EOT

# ==================================================
#       Dotfiles
# ==================================================
#dotfiles


