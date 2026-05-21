#!/bin/bash

green='\e[32m' 			          # Coloured echo (Green)
yellow=$'\033[38;5;11m' 	    # Coloured echo (yellow)
red=$'\033[0;31m'		          # Coloured echo (red)
r='tput sgr0' 		            # Reset colour after echo

# ------------------------------------------- // Initial Setup for Arch
loadkeys de				            # set keyboard
sudo pacman -Syyu --noconfirm 		      # update
sudo pacman -S archlinux-keyring && \   # if update fails add keyrings
sudo pacman-key --refresh-keys && \
sudo pacman -Syu && \
yay -Syu

sudo pacman -Sy linux			    # install latest linux kernel
yay -Syu 

# ------------------------------------------- // if Intel CPU
#pacman -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel intel-ucode
#pacman -S intel-ucode

[[ -d ${HOME}/Apps/Tools ]] || mkdir -p ${HOME}/Apps/Tools

# ====================================================================================================
#       Package Management
# ====================================================================================================
#################
# appmanager (am)		  - make AppImages of almost every package
if [[ ! -z $(which wget) ]]; then
  echo -e "${red}Wget fehlt. Installiere nach..."; $r
  sudo pacman -S wget
else
  wget -q https://raw.githubusercontent.com/ivan-hc/AM/main/AM-INSTALLER && chmod a+x ./AM-INSTALLER && ./AM-INSTALLER
  echo -e "${green}Paketmanager >>>appmanager (AM)<<< installiert."; $r
fi

#################
# yay				            - aur helper
sudo pacman -Sy --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
echo -e "${green}AUR helper >>>yay<<< installiert."; $r

#################
# eget				            - easily install Binaries from github repos
cd ${HOME}/Apps/Tools
mkdir [[ -d eget ]] || mkdir eget && cd "$_"
curl https://zyedidia.github.io/eget.sh | sh
echo -e "${green}Paketmanager >>>eget<<< installiert."; $r

#################
# init flatpak			        - applications packaged with all their dependencies 
yay -S flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
echo -e "${green}Paketmanager >>>flatpak<<< und Berechtigungsmanager >>>flatseal<<< installiert."; $r


# ====================================================================================================
#       cli
# ====================================================================================================
############################
# everything with FILES
# 
yay -S cups cups-pk-helper imagemagick gparted usbutils
yay -S fd bat jq 7z tar which pgrep git base-devel rclone rsync grsync fastfetch findutils grep xclip xkill
echo -e "${green}CLI File Tools installiert."; $r
# fd				            - find utility that is easy to use and allows filtering for eg extension or to execute unzip !!! can be used with batcat! fd … -X bat
# bat		    	            - better cat
echo "alias cat='bat'" >> ~/.aliases
# jq 				            - parse json files
# rclone			            - reliable copy utility
           


############################
# TERMINAL APPS
#
[[ -d ${HOME}/Apps/Tools ]] || mkdir -p ${HOME}/Apps/Tools

#################
#linutil         		        -automate stuff like user settings, updates etc. System agnostic
cd ${HOME}/Apps/Tools && mkdir linutil && cd linutil
yay -S linutil curl wget xclip
echo -e "${green}CLI TUI App >>>linutil<<< installiert."; $r

#################
# penguin-eggs			        - pack current system to iso
## outsourced -> pkg_multiline.lst

#################
# MY SCRIPT TO CHECK IF PACKAGE IS INSTALLED AND/OR AVAILABLE ANYWHERE
cd ${HOME}/Apps/Tools && [[ -d is-package-available ]] && mkdir is-package-available && cd is-package-available
curl -s --insecure --output is-package-available.sh "https://gist.github.com/Closer2U/82ef36afa351fd0ef0fff5cfce32afea/raw/320ab4db48ccc0d929c0b3b54da634026499fa09/is-package-available.sh"
chmod +x is-package-available.sh
echo "alias fdpackage='${HOME}/Apps/Tools/is-package-available/is-package-available.sh'" >> ~/.aliases

#################
# micro 			            - better than nano
eget zyedidia/micro
sudo mv micro /usr/local/bin
echo " ODER: curl https://getmic.ro | bash"
echo -e "${green}CLI TUI App >>>micro<<< installiert."; $r

#################
# wttr.in
##  handled in alias creation down there

############################
# no need to remember
#
# cht.sh 			            - Your Cheatsheet in the terminal
sudo pacman -S rlwrap
curl -s https://cht.sh/:cht.sh | sudo tee /usr/local/bin/cht.sh && sudo chmod +x /usr/local/bin/cht.sh
echo "alias cht='cht.sh'" >> ~/.aliases
echo -e "${green}CLI TUI App >>>cht.sh<<< installiert."; $r

# thefuck 			          - corrects errors in previous console commands.
sudo pacman -S thefuck

# howdoi			          - instant coding answers. Needs VPN outside EU
##  outsourced -> pkg_multiline.lst

############################
# SYSTEM MONITORING
#
[[ -d ${HOME}/Apps/Tools ]] || mkdir -p ${HOME}/Apps/Tools

mkdir btop && cd btop
# bashtop/bpytop/btop		  - System Monitoring in terminal
eget aristocratos/btop
echo -e "${green}CLI TUI App >>>btop<<< installiert."; $r

############################
# LOOKS and FEEL (shell)
#
#################
# ohmyzsh 			            - better shell
## --> outsourced to /functions/restore_zsh.sh
source /functions/restore_zsh.sh
bash /functions/restore_zsh.sh
# TODO take scripts from restore_shl.sh und siehe restore_zsh.lst
#   alternativ: dogrocker/oh-my-zsh-with...(gist) 
#   alternativ: MNMaqsood/oh-my-zsh-installer

# pywal 			      	    - this tool that adjusts terminal colors to background image
yay -S python-pywal
## automatically set the colors to current wallpaper
wal -i .local/share/backgrounds  

# ====================================================================================================
#       Coding and Development
# ====================================================================================================
# VSCode 		      	      - Coding IDE
yay -SY visual-studio-code-bin 

# Devpod 		      	      - Codespaces, but local in Podman 
## --> outsourced to /packages/pkg_multiline.lst

# setup podman wrapper for vscode in distrobox
## --> outsourced to /packages/pkg_multiline.lst

# ventoy		      	      - live boot utility usb maker
yay -Sy ventoy

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
#################
# Podman 		      	      - GUI for working with Containerfiles, like Docker. Needed for Distrobox
## --> outsourced installs via flatpak list

#################
# distrobox
#		      	    - 
### without sudo
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --prefix ~/.local
### GUI
## --> outsourced installs  via flatpak list

#################
# VMware 		      	      - free licence professional "VirtualBox"
## --> outsourced to /packages/pkg_multiline.lst
#
# gnomeboxes
## --> outsourced installs  via flatpak list

# ====================================================================================================
#       git
# ====================================================================================================
#zT via Flatpak
#main git s. oben via yay

# ====================================================================================================
#       security
# ====================================================================================================
# ufw
sudo pacman -Sy ufw ufw-extras
systemctl status ufw
ufw enable
ufw app list
ufw app info 'SSH'

# Proton VPN flatpak
#install via flatpak list


# ====================================================================================================
#       Personal Utilities
# ====================================================================================================
############################
# TEXT
# 
# Joplin
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash

############################
# INTERNET
# 
# raindrop.io
#
# bitwarden


# ====================================================================================================
#       GUI Apps
# ====================================================================================================
############################
# SYSTEM MONITORS
# 
# stacer					      - THE System Monitoring Tool
##curl -s ${curl -s https://api.github.com/repos/oguzhaninan/Stacer/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep "*.AppImage"}
am -i stacer

# flameshot				    	- Screenshot utility
yay -Sy flameshot

# S3Drive Client 				- for Clouds like Koofr and such
#install via flatpak list

# ====================================================================================================
#       CLEANUP
# ====================================================================================================
sudo pacman -Qdtq | pacman -Rns -		# removing orphanes
sudo pacman -Qqd | pacman -Rsu --print -
yay -Yc
yay -Ps						# system health


# handle abort on flatpak or additional packages
function continue_execution () {
    [ -z $1 ] && { flatpaks; extras; aliascreation; testing; } || $1
}
# ====================================================================================================
#       INSTALL from pkg_*.lst
# ====================================================================================================
### flatpak
function flatpaks () {
    scrDir="functions"
    baseDir="packages"
    source "${scrDir}/global_fn.sh"
    if [ $? -ne 0 ]; then
        echo "Error: unable to source global_fn.sh..."
        exit 1
    fi

    if ! pkg_installed flatpak; then
        sudo pacman -S flatpak
    fi

    function install_flats () {
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        flats=$(awk -F '#' '{print $1}' "${baseDir}/pkg_flat.lst" | sed 's/ //g' | xargs)

        flatpak install --user -y flathub ${flats}
        flatpak remove --unused
    }

    while true; do
        read -p "Did you comment-out those flatpak packages you do NOT wish to install? " yn
        case $yn in
            [Yy]* ) install_flats ;;
            [Nn]* ) echo 'Please do so now and start the script again with the parameter "flatpaks".' && return;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}
flatpaks

### additional resources that go beyond this core installation

function extras () {
    function install_extra_packages() {
        source packages/pkg_multiline.lst.sh
    }
    while true; do
        read -p "Did you comment-out those packages you do NOT wish to install? " yn
        case $yn in
            [Yy]* ) install_extra_packages ;;
            [Nn]* ) echo 'Please do so now by editing the file "/packages/pkg_multiline.lst.sh" and start the script again with the parameter "extras".' && return;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}
extras

function testing () {
    echo "test successfull"
}


function aliascreation () {
# ====================================================================================================
#       ALIAS bzw. .bashrc/.zshrc
# ====================================================================================================

# --> outourced to /functions/alias-creation.sh
        source "functions/alias-creation.sh"
        bash functions/alias-creation.sh
}
aliascreation

continue_execution "$@"

# ====================================================================================================
#       Dotfiles
# ====================================================================================================
#dotfiles

