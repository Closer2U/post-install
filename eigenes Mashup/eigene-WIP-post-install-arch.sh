#!/bin/bash

green='\e[32m' 			    # Coloured echo (Green)
yellow=$'\033[38;5;11m' 	# Coloured echo (yellow)
red=$'\033[0;31m'		    # Coloured echo (red)
r='tput sgr0' 		     	# Reset colour after echo

# ------------------------------------------- // Initial Setup
loadkeys de				# set keyboard
sudo pacman -Syyu --noconfirm 		# update
sudo pacman -S archlinux-keyring && \   # if update fails add keyrings
sudo pacman-key --refresh-keys && \
sudo pacman -Syu && \
yay -Syu

sudo pacman -Sy linux			# install latest linux kernel
yay -Syu 

# ------------------------------------------- // if Intel CPU
#pacman -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel intel-ucode
#pacman -S intel-ucode

[[ -d ${HOME}/Apps/Tools ]] || mkdir -p ${HOME}/Apps/Tools

# ==================================================
#       Package Management
# ==================================================
#################
# appmanager (am)		- make AppImages of almost every package
if [[ ! -z $(which wget) ]]; then
  echo -e "${red}Wget fehlt. Installiere nach..."; $r
  sudo pacman -S wget
else
  wget -q https://raw.githubusercontent.com/ivan-hc/AM/main/AM-INSTALLER && chmod a+x ./AM-INSTALLER && ./AM-INSTALLER
  echo -e "${green}Paketmanager >>>appmanager (AM)<<< installiert."; $r
fi

#################
# yay				- aur helper
sudo pacman -Sy --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
echo -e "${green}AUR helper >>>yay<<< installiert."; $r

#################
# init flatpak			- applications packaged with all their dependencies 
yay -S flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.github.tchx84.Flatseal
echo -e "${green}Paketmanager >>>flatpak<<< und Berechtigungsmanager >>>flatseal<<< installiert."; $r

#################
# eget				- easily install Binaries from github repos
cd ${HOME}/Apps/Tools
mkdir [[ -d eget ]] || mkdir eget && cd "$_"
curl https://zyedidia.github.io/eget.sh | sh
echo -e "${green}Paketmanager >>>eget<<< installiert."; $r


# ==================================================
#       cli
# ==================================================
############################
# everything with FILES
# 
yay -S cups cups-pk-helper imagemagick gparted usbutils
yay -S fd bat jq 7z tar which pgrep git base-devel rclone rsync grsync fastfetch findutils grep xclip xkill
echo -e "${green}CLI File Tools installiert."; $r
#fd				- find utility that is easy to use and allows filtering for eg extension or to execute unzip !!! can be used with batcat! fd … -X bat
# bat			- better cat
echo "alias cat='bat'" >> ~/.aliases
# jq 				- parse json files
# rclone			- reliable copy utility


############################
# TERMINAL APPS
#
[[ -d ${HOME}/Apps/Tools ]] || mkdir -p ${HOME}/Apps/Tools

#################
#linutil         		  - automate stuff like user settings, updates etc. System agnostic
cd ${HOME}/Apps/Tools && mkdir linutil && cd linutil
yay -S linutil curl wget xclip
echo -e "${green}CLI TUI App >>>linutil<<< installiert."; $r

#################
# penguin-eggs			  - pack current system to iso
cd ${HOME}/Apps/Tools && mkdir iso-management && cd iso-management
#yay penguins-eggs
git clone https://github.com/pieroproietti/penguins-eggs
cd penguins-eggs
sudo ./get-eggs
sudo eggs calamares --install
echo -e "${green}penguin-egg zum Packen des Systems als iso installiert."; $r
echo -e "${yellow}Siehe Anleitung unter https://penguins-eggs.net/docs/Tutorial/eggs-users-guide"; $r
echo ""

#################
# MY SCRIPT TO CHECK IF PACKAGE IS INSTALLED AND/OR AVAILABLE ANYWHERE
cd ${HOME}/Apps/Tools && [[ -d is-package-available ]] && mkdir is-package-available && cd is-package-available
curl -s --insecure --output is-package-available.sh "https://gist.github.com/Closer2U/82ef36afa351fd0ef0fff5cfce32afea/raw/320ab4db48ccc0d929c0b3b54da634026499fa09/is-package-available.sh"
chmod +x is-package-available.sh
echo "alias fdpackage='${HOME}/Apps/Tools/is-package-available/is-package-available.sh'" >> ~/.aliases

#################
# micro 			  - better than nano
eget zyedidia/micro
sudo mv micro /usr/local/bin
echo " ODER: curl https://getmic.ro | bash"
echo -e "${green}CLI TUI App >>>micro<<< installiert."; $r

#################
# wttr.in
echo "alias wttrL='curl wttr.in/04109'" >> ~/.aliases
echo "alias wttrH='curl wttr.in/halle-saale'" >> ~/.aliases
echo -e "${green}CLI TUI App alias für >>>wttr.in<<< Halle und Leipzig gesetzt."; $r

############################
# no need to remember
#
# cht.sh 			   - Your Cheatsheet in the terminal
sudo pacman -S rlwrap
curl -s https://cht.sh/:cht.sh | sudo tee /usr/local/bin/cht.sh && sudo chmod +x /usr/local/bin/cht.sh
echo "alias cht='cht.sh'" >> ~/.aliases
echo -e "${green}CLI TUI App >>>cht.sh<<< installiert."; $r

# thefuck 			   - corrects errors in previous console commands.
sudo pacman -S thefuck

# howdoi			    - instant coding answers. Needs VPN outside EU
cd cd ${HOME}/Apps/Tools/Assistent
python3 -m venv venv-howdoi && source venv-howdoi/bin/activate 
pip3 install howdoi       # Programm ist nur bei aktiver virtueller Umgebung nutzbar  

############################
# SYSTEM MONITORING
#
[[ -d ${HOME}/Apps/Tools ]] || mkdir -p ${HOME}/Apps/Tools

mkdir btop && cd btop
# bashtop/bpytop/btop		   - System Monitoring in terminal
eget aristocratos/btop
echo -e "${green}CLI TUI App >>>btop<<< installiert."; $r

############################
# LOOKS and FEEL (shell)
#
#################
# ohmyzsh 			    - better shell
sudo pacman -S zsh fonts-powerline
#curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
sh -c "$(curl -fsSL https://install.ohmyz.sh/)"
echo -e "${green}Installiere zsh."; $r
chsh -s $(which zsh)
echo -e "--- ${green}Setze zsh als default shell."; $r
echo $0
cd ${HOME}/Apps/Tools
mkdir zsh && cd zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
echo -e "--- ${green}Installiere autosuggestion."; $r
cd ..
it clone https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete  
echo -e "--- ${green}Installiere autocompletion."; $r
cd ..
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting  
echo -e "--- ${green}Installiere syntax highlighting."; $r
git clone https://github.com/akash329d/zsh-alias-finder ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-alias-finder
sed -i -e 's/plugins=(/plugins=(zsh-alias-finder zsh-autosuggestions zsh-autocompletion zsh-syntax-highlighting /g' ~/.zshrc
echo -e "--- ${green}Installiere zsh alias finder."; $r
sed -i -e 's/`cat ~/.zshrc | grep ZSH_THEME`/ZSH_THEME="jonathan"/g' ~/.zshrc
# wget -O ~/.oh-my-zsh/themes/kali-like.zsh-theme https://raw.githubusercontent.com/clamy54/kali-like-zsh-theme/master/kali-like.zsh-theme
#sed -i -e 's/`cat ~/.zshrc | grep ZSH_THEME`/ZSH_THEME="kali-like"/g' ~/.zshrc
echo -e "--- ${green}Wechsle zsh theme. Auskommentiert ist kali."; $r
source ~/.zshrc

# pywal 				- this tool that adjusts terminal colors to background image
yay -S python-pywal

# nerdfonts
#curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash
yay -S getnf				# choose: noto-fonts noto-fonts-cjk ttf-dejavu ttf-liberation ttf-opensans
fc-cache				# update font cache

# ==================================================
#       Coding and Development
# ==================================================
# VSCode 			- Coding IDE
yay -SY visual-studio-code-bin 

# Devpod 			- Codespaces, but local in Podman 
cd ${HOME}/Apps/Tools && mkdir Devpod && cd Devpod
eget https://github.com/loft-sh/devpod/releases/latest/download/DevPod_linux_x86_64.tar.gz --file Devpods --to ${HOME}/Apps/Tools/Devpod
# eget loft-sh/devpod
echo -e "${green}Devpod installiert."; $r

###################
# setup podman wrapper for vscode in distrobox
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/extras/podman-host -o ~/.local/bin/podman-host
chmod +x ~/.local/bin/podman-host
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/extras/vscode-distrobox -o ~/.local/bin/vscode-distrobox
chmod +x ~/.local/bin/vscode-distrobox
echo "alias code-distro='echo vscode-distrobox my-distrobox /path/to/project'" >> ~/.aliases
echo -e "${yellow}========================================================================================"; $r
echo -e "${green}Podman Wrapper für VSCode development via distrobox gesetzt."; $r
echo -e "--- ${yellow}In VSCode bitte >ext install ms-vscode-remote.remote-containers< installieren."
echo -e "--- ${yellow}In VSCode bitte 'Remote>Containers>Docker Path' aufrufen und '/home/<your-user>/.local/bin/podman-host' setzen.\nSiehe https://distrobox.it/posts/integrate_vscode_distrobox/ für Details."; $r

echo -e "${yellow}========================================================================================"; $r

# ventoy			- live boot utility usb maker
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
# Podman 			- GUI for working with Containerfiles, like Docker. Needed for Distrobox
flatpak install flathub io.podman_desktop.PodmanDesktop
echo -e "${green}Podman Desktop successfully installed."; $r

#################
# distrobox			- 
### without sudo
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --prefix ~/.local
### GUI
flatpak install flathub io.github.dvlv.boxbuddyrs

#################
# VMware 			- free licence professional "VirtualBox"
#[[ -d ${HOME}/Apps ]] || mkdir ${HOME}Apps
echo -e "${y}Downloading and extracting VMWare Workstation."; $r
mkdir -p ${HOME}/Apps/Virtualisierung && cd ${HOME}/Apps/Virtualisierung && curl -L -s https://softwareupdate.vmware.com/cds/vmw-desktop/ws/17.6.1/24319023/linux/core/VMware-Workstation-17.6.1-24319023.x86_64.bundle.tar | tar -zx -C ${HOME}/Apps/
sudo chmod +x VMware-Workstation-*.x86_64.bundle
sudo nala install gcc-12 libgcc-12-dev build-essential -y
sudo ./${ls | grep VMWare*.bundle}
echo -e "${green}VMWare Workstation successfully installed."; $r

# gnomeboxes
flatpak install flathub org.gnome.Boxes

# ==================================================
#       git
# ==================================================

# ==================================================
#       security
# ==================================================

# ufw
sudo pacman -Sy ufw ufw-extras
systemctl status ufw
ufw enable
ufw app list
ufw app info 'SSH'

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

# flameshot					- Screenshot utility
yay -Sy flameshot

# S3Drive Client 				- for Clouds like Koofr and such
#sudo nala install rclone
flatpak install flathub io.kapsa.drive

# ==================================================
#       CLEANUP
# ==================================================
sudo pacman -Qdtq | pacman -Rns -		# removing orphanes
sudo pacman -Qqd | pacman -Rsu --print -
yay -Yc
yay -Ps						# system health

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

#alias update="sudo nala update -y && sudo nala upgrade -y && sudo nala autoremove -y && snap refresh && flatpak update -y && pacstall -U && pacstall -Up && am -u && wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash && am -f && pacstall -L && snap list && flatpak list" 

alias update="sudo pacman -Su && yay -Su && flatpak update -y && am -u && wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash && sudo pacman -Qdtq | pacman -Rns - && sudo pacman -Qqd | pacman -Rsu --print - && yay -Yc && am -f"


#######################
## PROCESS MANAGEMENT
# easier Process identification
alias psaux="ps aux | grep"
alias hg="history | grep "

##xclip alias dieses ewig lange sel command

#######################
## Program shorthands
alias cht="cht.sh"
alias cat="bat"

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

