#!/bin/bash

green='\e[32m' 			          # Coloured echo (Green)
yellow=$'\033[38;5;11m' 	    # Coloured echo (yellow)
red=$'\033[0;31m'		          # Coloured echo (red)
r='tput sgr0' 		            # Reset colour after echo

# ------------------------------------------- // Initial Setup
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
# cups              


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
##  outsourced to pkg_multiline.lst

###################
# setup podman wrapper for vscode in distrobox
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/extras/podman-host -o ~/.local/bin/podman-host
chmod +x ~/.local/bin/podman-host
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/extras/vscode-distrobox -o ~/.local/bin/vscode-distrobox
chmod +x ~/.local/bin/vscode-distrobox
echo "alias code-distro='echo vscode-distrobox my-distrobox /path/to/project'" >> ~/.aliases
echo -e "${yellow}=========================================================================================================================================="; $r
echo -e "${green}Podman Wrapper für VSCode development via distrobox gesetzt."; $r
echo -e "--- ${yellow}In VSCode bitte >ext install ms-vscode-remote.remote-containers< installieren."
echo -e "--- ${yellow}In VSCode bitte 'Remote>Containers>Docker Path' aufrufen und '/home/<your-user>/.local/bin/podman-host' setzen.\nSiehe https://distrobox.it/posts/integrate_vscode_distrobox/ für Details."; $r

echo -e "${yellow}=========================================================================================================================================="; $r

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
#install via flatpak list

#################
# distrobox
#		      	    - 
### without sudo
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --prefix ~/.local
### GUI
#install via flatpak list

#################
# VMware 		      	      - free licence professional "VirtualBox"
##  outsourced to pkg_multiline.lst
#
# gnomeboxes
#install via flatpak list

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
#WIP
cp ${HOME}/.bashrc {HOME}/.bashrc_backup
[[ -f ${HOME}/.zshrc ]] || cp ${HOME}/.zshrc ${HOME}/.zshrc_backup
echo -e "${c}Richte .bashrc ein."; $r

cat <<EOT >> .bashrc
# restore pywal theme
wal -R && clear

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi
EOT

[[ -f ${HOME}/.zshrc ]] || cat <<EOT >> .zshrc
# restore pywal theme
wal -R && clear

# enable auto-suggestions based on the history
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # change suggestion color
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

# enable command-not-found if installed
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi
if [ -f ~/.zsh_alias ]; then
    . ~/.zsh_alias
fi
EOT

cat <<EOT >> .aliases
#######################
## PACKAGE MANAGEMENT
## aliases for install and update + add updates separately for eg zsh, pip3 list --outdated --format=freeze | grep [...]

# universal
alias update=" if [ $(cat /etc/os-release|grep ID_LIKE| grep debian) ]; then sudo nala update && sudo nala upgrade && sudo nala autoremove && snap refresh && flatpak update -y && pacstall -U && pacstall -Up && am -u && wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash && am -f && pacstall -L && echo '===================================== installed FLATPAKs =====================================' && echo '===================================== installed SNAPs =====================================' && snap list   && echo '===================================== installed FLATPAKs =====================================' && flatpak list; elif [ $(cat /etc/os-release|grep ID| grep arch) ]; then sudo pacman -Su && yay -Su && flatpak update -y && am -u && wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash && sudo pacman -Qdtq | pacman -Rns - && sudo pacman -Qqd | pacman -Rsu --print - && yay -Yc && am -f && echo '===================================== installed FLATPAKs =====================================' && flatpak list; fi"

# for debian based
#alias update="sudo nala update && sudo nala upgrade && sudo nala autoremove  && snap refresh && flatpak update -y && pacstall -U && pacstall -Up && am -u && wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash && am -f && pacstall -L && echo '===================================== installed FLATPAKs =====================================' && flatpak list && echo '===================================== installed SNAPs =====================================' && snap list" 

# for arch based
#alias update="sudo pacman -Su && yay -Su && flatpak update -y && am -u && wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash && sudo pacman -Qdtq | pacman -Rns - && sudo pacman -Qqd | pacman -Rsu --print - && yay -Yc && am -f && flatpak list"

########################
## FILES
# shortcut for finding files in directory
alias lsgrep="ls | grep "

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias ll="ls -laht"
    alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Pack and Extract Archives
alias untar="tar -xafv " # Syntax: tar -xaf destinationFileName sourceFileName
alias maxcompress="test $# -gt 0 || { echo '    [❗]>> Syntax: maxcompress <output>.7z <in-folder-or-file>/'; sleep 5s && return; } || 7z a -t7z -m0=lzma -mx=9 -mfb=64 -mmt=off -md=128m -bd -bb0 "
alias tgz="tar -cafv "
alias targz="tar -cafv "
alias targz-max="tar -czvf "

### install deb package (debian/ubuntu only)
alias dbkg-i="cd ~/Downloads && grep '.deb' '$(ls -1rt ~/Downloads | tail -n1)' | xargs -I% sudo dpkg -i '%.deb'"

#######################
## INTERNET
alias mtu="ifconfig | grep mtu"                                                       # list mtu sizes
alias mtu-fix='sudo ifconfig wlp3s0 mtu 1400 up && sudo ifconfig enp0s25 mtu 1400 up' # reduce mtu size to enable stackfield and git at M
alias myip='curl ipinfo.io/ip'                                                        # Print my public IP

#######################
## PROCESS MANAGEMENT
# easier Process identification
alias psaux="ps aux | grep"
alias hg="history | grep "

########################
## PROGRAM SHORTHANDS
alias cht="cht.sh"
alias cat="bat"

########################
## CLIPBOARD HANDLING
# easier copying from clipboard esp. file output
# Bsp: pwd | c
alias "c=xclip -selection clipboard" # copy to system wide clipboard (register +)"

########################
## NAVIGATION


######################
## SERVICES
# list all active Services
alias lsservice="service --status-all"

######################
## MISC
# git
alias git-sort-size="git rev-list --objects --all --missing=print |   git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |   sed -n 's/^blob //p' |   sort --numeric-sort --key=2 |   cut -c 1-12,41- |   $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest"

EOT

[[ -f ${HOME}/.zshrc_alias ]] || cat <<EOT >> .zshrc_alias

# colorized help messages via bat
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

EOT
}
aliascreation

continue_execution "$@"
# ====================================================================================================
#       Dotfiles
# ====================================================================================================
#dotfiles

