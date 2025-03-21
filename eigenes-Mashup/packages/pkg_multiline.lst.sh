#! /bin/bash

# ------------------------------------------------------------------------------------------- // Shell
# howdoi              - interactive programming answers
function how_do_i () {
cd ${HOME}/Apps/Tools/Assistent
python3 -m venv venv-howdoi && source venv-howdoi/bin/activate 
pip3 install howdoi       # Programm ist nur bei aktiver virtueller Umgebung nutzbar  
}

# -------------------------------------------------------------------------------------------  // Iso-Management
# penguine-eggs        - create iso from current system 
function penguin_eggs () {
    cd ${HOME}/Apps/Tools && mkdir iso-management && cd iso-management
    #yay penguins-eggs
    git clone https://github.com/pieroproietti/penguins-eggs
    cd penguins-eggs
    sudo ./get-eggs
    sudo eggs calamares --install
    echo -e "${green}penguin-egg zum Packen des Systems als iso installiert."; $r
    echo -e "${yellow}Siehe Anleitung unter https://penguins-eggs.net/docs/Tutorial/eggs-users-guide"; $r
    echo ""
}

# -------------------------------------------------------------------------------------------  // Terminal Styling
# nerdfonts
function nerd_fonts () {
    #curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash
    yay getnf				# choose: noto-fonts noto-fonts-cjk ttf-dejavu ttf-liberation ttf-opensans
    fc-cache			    # update font cache
}

# -------------------------------------------------------------------------------------------  // Development/Virtualization
# Devpod 		      	- Codespaces, but local in Podman 
function devpod () {
    cd ${HOME}/Apps/Tools && mkdir -p Virtualization/Devpod && cd Devpod
    eget https://github.com/loft-sh/devpod/releases/latest/download/DevPod_linux_x86_64.tar.gz --file Devpods --to ${HOME}/Apps/Tools/Devpod
    # eget loft-sh/devpod
    echo -e "${green}Devpod installiert."; $r
}

# VMware 		      	 - free licence professional "VirtualBox"
function vm_ware() {
    cd ${HOME}/Apps/Tools && mkdir -p Virtualization/VMWare && cd VMWare
    echo -e "${y}Downloading and extracting VMWare Workstation."; $r
    mkdir -p ${HOME}/Apps/Virtualisierung && cd ${HOME}/Apps/Virtualisierung && curl -L -s https://softwareupdate.vmware.com/cds/vmw-desktop/ws/17.6.1/24319023/linux/core/VMware-Workstation-17.6.1-24319023.x86_64.bundle.tar | tar -zx -C ${HOME}/Apps/
    sudo chmod +x VMware-Workstation-*.x86_64.bundle
    sudo nala install gcc-12 libgcc-12-dev build-essential -y
    sudo ./${ls | grep VMWare*.bundle}
    echo -e "${green}VMWare Workstation successfully installed."; $r
}

# -------------------------------------------------------------------------------------------  // 

# -------------------------------------------------------------------------------------------  // 

###### software to install #####
#how_do_i 
penguin_eggs
#nerd_fonts 
devpod
#vm_ware