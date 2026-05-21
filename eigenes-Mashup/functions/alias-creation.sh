#! /bin/bash


# ====================================================================================================
#       ALIAS bzw. .bashrc/.zshrc
# ====================================================================================================
#WIP

cd ~

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
if [ -f ~/.oh-my-zsh ]; then
    . ~/.oh-my-zsh
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


[[ -f ${HOME}/.oh-my-zsh ]] || cat <<EOT >> .oh-my-zsh 

# for the "alias-finder" plugin
zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default
zstyle ':omz:plugins:alias-finder' longer yes # disabled by default
zstyle ':omz:plugins:alias-finder' exact yes # disabled by default
zstyle ':omz:plugins:alias-finder' cheaper yes # disabled by default

EOT