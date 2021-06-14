#!/data/data/com.termux/files/usr/bin/bash

## Author  : Aditya Shakya (adi1090x)
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x
## Mod	   : @Afonsoft

## Termux Desktop : Setup GUI in Termux 

## ANSI Colors (FG & BG)
RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"  GREENBG="$(printf '\033[42m')"  ORANGEBG="$(printf '\033[43m')"  BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"  WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"

## Reset terminal colors
reset_color() {
	printf '\033[37m'
}

## Script Termination
exit_on_signal_SIGINT() {
    { printf "${RED}\n\n%s\n\n" "[!] Program Interrupted." 2>&1; reset_color; }
    exit 0
}

exit_on_signal_SIGTERM() {
    { printf "${RED}\n\n%s\n\n" "[!] Program Terminated." 2>&1; reset_color; }
    exit 0
}

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

## Banner
banner() {
	clear
    cat <<- EOF
		${RED}┌────────────────────────────────────────────────────────┐
		${RED}│${GREEN}░▀█▀░█▀▀░█▀▄░█▄█░█░█░█░█░░░█▀▄░█▀▀░█▀▀░█░█░▀█▀░█▀█░█▀█░░${RED}│
		${RED}│${GREEN}░░█░░█▀▀░█▀▄░█░█░█░█░▄▀▄░░░█░█░█▀▀░▀▀█░█▀▄░░█░░█░█░█▀▀░░${RED}│
		${RED}│${GREEN}░░▀░░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░▀░░░▀▀░░▀▀▀░▀▀▀░▀░▀░░▀░░▀▀▀░▀░░░░${RED}│
		${RED}└────────────────────────────────────────────────────────┘
		${BLUE}By : Aditya Shakya // @adi1090x
		${BLUE}Mod : Afonso Nogueira // @afonsoft
	EOF
}

## Show usages
usage() {
	banner
	echo -e ${ORANGE}"\nInstall GUI (xfce4 Desktop) on Termux"
	echo -e ${ORANGE}"Usages: $(basename $0) --install | --uninstall | --compile"
	echo -e ${ORANGE}"Usages: $(basename $0) --compile for xfce4-dev-tools and intltool"
	echo -e ${ORANGE}"Usages: $(basename $0) --tools for Visual Studio Code and Firefox"
	echo -e ${ORANGE}"if compile error use compile-install.sh\n"
}

## Update, X11-repo, Program Installation
_pkgs=(bc bmon calc calcurse curl dbus desktop-file-utils elinks feh fontconfig-utils fsmon \
		geany git gtk2 gtk3 htop-legacy imagemagick jq leafpad man mpc mpd mutt ncmpcpp \
		ncurses-utils neofetch netsurf obconf xfce4 openssl-tool polybar ranger rofi \
		startup-notification termux-api thunar tigervnc vim wget xarchiver xbitmaps xcompmgr \
		xfce4-settings xfce4-terminal xmlstarlet xorg-font-util xorg-xrdb zsh \
		librsvg nodejs yarn build-essential bash-completion gdk-pixbuf ripgrep xfce4-taskmanager \
		dosbox vim-gtk python-tkinter loqui the-powder-toy galculator xorg-xhost mpv ristretto \
		xfce4-whiskermenu-plugin xfce4-clipman-plugin xarchiver geany-plugins mtpaint hexchat \
		recordmydesktop uget neovim perl ruby rust texlive-installer)

setup_base() {
	echo -e ${RED}"\n[*] Installing Termux Desktop..."
	echo -e ${CYAN}"\n[*] Updating Termux Base... \n"
	{ reset_color; pkg autoclean; pkg update; pkg upgrade -y; }
	echo -e ${CYAN}"\n[*] Enabling Termux X11-repo, science-repo, etc... \n"
	{ 
		reset_color; 
		pkg install -y x11-repo; 
		pkg install -y unstable-repo; 
		pkg install -y game-repo;
		pkg install -y science-repo;
	}
	echo -e ${CYAN}"\n[*] Installing required programs... \n"
	for package in "${_pkgs[@]}"; do
		{ reset_color; pkg install -y "$package"; }
		_ipkg=$(pkg list-installed $package 2>/dev/null | tail -n 1)
		_checkpkg=${_ipkg%/*}
		if [[ "$_checkpkg" == "$package" ]]; then
			echo -e ${GREEN}"\n[*] Package $package installed successfully.\n"
			continue
		else
			{ pkg autoclean; pkg update; pkg upgrade -y; }
			echo -e ${RED}"\n[!] Error installing $package, Terminating...\n"
			echo -e ${MAGENTA}"\n[!] Run pkg upgrade -y and ./setup.sh --install agian \n"
			{ reset_color; exit 1; }
		fi
	done
	reset_color
}
## Install ZSH
install_zsh () {
	{ echo ${ORANGE}" [*] Installing ZSH..."${CYAN}; echo; }
	if [[ -f $PREFIX/bin/zsh ]]; then
		{ echo ${GREEN}" [*] ZSH is already Installed!"; echo; }
	else
		{ pkg update -y; pkg install -y zsh; }
		(type -p zsh &> /dev/null) && { echo; echo ${GREEN}" [*] Succesfully Installed!"; echo; } || { echo; echo ${RED}" [!] Error Occured, ZSH is not installed."; echo; reset_color; exit 1; }
	fi
}

## Setup OMZ and Termux Configs
setup_omz() {
	# backup previous termux and omz files
	echo -e ${GREEN}"[*] Setting up OMZ and termux configs..."
	omz_files=(.oh-my-zsh .termux .zshrc)
	for file in "${omz_files[@]}"; do
		echo -e ${CYAN}"\n[*] Backing up $file..."
		if [[ -f "$HOME/$file" || -d "$HOME/$file" ]]; then
			{ reset_color; mv -u ${HOME}/${file}{,.old}; }
		else
			echo -e ${MAGENTA}"\n[!] $file Doesn't Exist."			
		fi
	done
	# installing omz
	echo -e ${CYAN}"\n[*] Installing Oh-my-zsh... \n"
	{ reset_color; git clone https://github.com/robbyrussell/oh-my-zsh.git --depth 1 $HOME/.oh-my-zsh; }
	cp $HOME/.oh-my-zsh/templates/zshrc.zsh-template $HOME/.zshrc
	sed -i -e 's/ZSH_THEME=.*/ZSH_THEME="aditya"/g' $HOME/.zshrc
	sed -i -e 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' $HOME/.zshrc
	sed -i -e 's|# export PATH=.*|export PATH=$HOME/.local/bin:$PATH|g' $HOME/.zshrc
	# ZSH theme
	cat > $HOME/.oh-my-zsh/custom/themes/aditya.zsh-theme <<- _EOF_
		# Default OMZ theme

		if [[ "\$USER" == "root" ]]; then
		  PROMPT="%(?:%{\$fg_bold[red]%}%{\$fg_bold[yellow]%}%{\$fg_bold[red]%} :%{\$fg_bold[red]%} )"
		  PROMPT+='%{\$fg[cyan]%}  %c%{\$reset_color%} \$(git_prompt_info)'
		else
		  PROMPT="%(?:%{\$fg_bold[red]%}%{\$fg_bold[green]%}%{\$fg_bold[yellow]%} :%{\$fg_bold[red]%} )"
		  PROMPT+='%{\$fg[cyan]%}  %c%{\$reset_color%} \$(git_prompt_info)'
		fi

		ZSH_THEME_GIT_PROMPT_PREFIX="%{\$fg_bold[blue]%}  git:(%{\$fg[red]%}"
		ZSH_THEME_GIT_PROMPT_SUFFIX="%{\$reset_color%} "
		ZSH_THEME_GIT_PROMPT_DIRTY="%{\$fg[blue]%}) %{\$fg[yellow]%}✗"
		ZSH_THEME_GIT_PROMPT_CLEAN="%{\$fg[blue]%})"
	_EOF_
	# Append some aliases
	cat >> $HOME/.zshrc <<- _EOF_
		#------------------------------------------
		alias l='ls -lh'
		alias ll='ls -lah'
		alias la='ls -a'
		alias ld='ls -lhd'
		alias p='pwd'

		#alias rm='rm -rf'
		alias u='cd $PREFIX'
		alias h='cd $HOME'
		alias :q='exit'
		alias grep='grep --color=auto'
		alias open='termux-open'
		alias lc='lolcat'
		alias xx='chmod +x'
		alias rel='termux-reload-settings'

		#------------------------------------------

		# SSH Server Connections

		# linux (Arch)
		alias arch='ssh UNAME@IP -i ~/.ssh/id_rsa.DEVICE'

		# linux sftp (Arch)
		alias archfs='sftp -i ~/.ssh/id_rsa.DEVICE UNAME@IP'
	_EOF_

	# configuring termux
	echo -e ${CYAN}"\n[*] Configuring Termux..."
	if [[ ! -d "$HOME/.termux" ]]; then
		mkdir $HOME/.termux
	fi
	# button config
	cat > $HOME/.termux/termux.properties <<- _EOF_
		extra-keys = [ \\
		 ['ESC','|', '/', '~','HOME','UP','END'], \\
		 ['CTRL', 'TAB', '=', '-','LEFT','DOWN','RIGHT'] \\
		]	
	_EOF_
	# change shell and reload configs
	{ chsh -s zsh; termux-reload-settings; termux-setup-storage; }
	if [[ ! -d "$HOME/Downloads" ]]; then
		mkdir $HOME/Downloads 
	fi
	if [[ ! -d "$HOME/Templates" ]]; then
		mkdir $HOME/Templates 
	fi
	if [[ ! -d "$HOME/Public" ]]; then
		mkdir $HOME/Public
	fi
	if [[ ! -d "$HOME/Documents" ]]; then
		mkdir $HOME/Documents 
	fi
	if [[ ! -d "$HOME/Pictures" ]]; then
		mkdir $HOME/Pictures 
	fi
	if [[ ! -d "$HOME/Video" ]]; then
		mkdir $HOME/Video 
	fi
	if [[ ! -d "$HOME/Pictures/backgrounds" ]]; then
		mkdir $HOME/Pictures/backgrounds
	fi
}

## Configuration
setup_config() {
	# backup
	configs=($(ls -A $(pwd)/files))
	echo -e ${GREEN}"\n[*] Backing up your files and dirs... "
	for file in "${configs[@]}"; do
		echo -e ${CYAN}"\n[*] Backing up $file..."
		if [[ -f "$HOME/$file" || -d "$HOME/$file" ]]; then
			{ reset_color; mv -u ${HOME}/${file}{,.old}; }
		else
			echo -e ${MAGENTA}"\n[!] $file Doesn't Exist."			
		fi
	done
	
	# Copy config files
	echo -e ${GREEN}"\n[*] Coping config files... "
	for _config in "${configs[@]}"; do
		echo -e ${CYAN}"\n[*] Coping $_config..."
		{ reset_color; cp -rf $(pwd)/files/$_config $HOME; }
	done
	if [[ ! -d "$HOME/Desktop" ]]; then
		mkdir $HOME/Desktop
	fi
}

## Setup VNC Server
setup_vnc() {
	# backup old dir
	if [[ -d "$HOME/.vnc" ]]; then
		mv $HOME/.vnc{,.old}
	fi
	echo -e ${RED}"\n[*] Setting up VNC Server..."
	{ reset_color; vncserver -localhost; }
	sed -i -e 's/# geometry=.*/geometry=1366x768/g' $HOME/.vnc/config
	cat > $HOME/.vnc/xstartup <<- _EOF_
		#!/data/data/com.termux/files/usr/bin/bash
		## This file is executed during VNC server
		## startup.
		unset SESSION_MANAGER
		unset DBUS_SESSION_BUS_ADDRESS
		export XKL_XMODMAP_DISABLE=1
		xsetroot -solid grey
		vncconfig -iconic &
		# Launch x-session-manager
		startxfce4 &
		# Launch xhost service to run proot-distro apps
		xhost +localhost
		xhost +
	_EOF_
	if [[ $(pidof Xvnc) ]]; then
		    echo -e ${ORANGE}"[*] Server Is Running..."
		    { reset_color; vncserver -list; }
	fi
}

## Copy file of config
setup_theme(){
echo -e ${GREEN}"\n[*] Setup theme file... "
	echo -e ${CYAN}"\n[*] Coping font file... "
	cp $(pwd)/files/.fonts/icons/font.ttf $HOME/.termux/font.ttf
	echo -e ${CYAN}"\n[*] Coping colors file... "
	cp $(pwd)/colors.properties $HOME/.termux/colors.properties
	echo -e ${CYAN}"\n[*] Coping xfce4 xfconf file... "
	cp -rf $(pwd)/backgrounds/* $HOME/Pictures/backgrounds
	cp -rf $(pwd)/backgrounds/* $PREFIX/usr/share/backgrounds
	cp -rf $(pwd)/files/.icons/Flatery/* $HOME/.local/share/icons/Flatery
	cp -rf $(pwd)/files/.icons/Flatery/* $PREFIX/usr/share/icons/Flatery
	{ 
		termux-reload-settings; 
		xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor0/image-path --set $HOME/Pictures/backgrounds/Mousy_X78_2K_W.png;
	}
}

## Create Launch Script
setup_launcher() {
	file="$HOME/.local/bin/startdesktop"
	if [[ -f "$file" ]]; then
		rm -rf "$file"
	fi
	echo -e ${GREEN}"\n[*] Creating Launcher Script... \n"
	{ reset_color; touch $file; chmod +x $file; }
	cat > $file <<- _EOF_
		#!/data/data/com.termux/files/usr/bin/bash

		# Export Display
		export DISPLAY=":1"

		# Start VNC Server
		if [[ \$(pidof Xvnc) ]]; then
		    echo -e "\\n[!] Server Already Running."
		    { vncserver -list; echo; }
		    read -p "Kill VNC Server? (Y/N) : "
		    if [[ "\$REPLY" == "Y" || "\$REPLY" == "y" ]]; then
		        { killall Xvnc; echo; }
		    else
		        echo
		    fi
		else
		    echo -e "\\n[*] Starting VNC Server..."
		    vncserver
		fi
	_EOF_
	if [[ -f "$file" ]]; then
		echo -e ${GREEN}"[*] Script ${ORANGE}$file ${GREEN}created successfully."
	fi
}

## Finish Installation
post_msg() {
echo -e ${GREEN}"\n[*] ${RED}Termux Desktop ${GREEN}Clean tempory files....\n"
	{ git clean -d  -fx; }
	echo -e ${GREEN}"\n[*] ${RED}Termux Desktop ${GREEN}Installed Successfully.\n"
	cat <<- _MSG_
		[-] Restart termux and enter ${ORANGE}startdesktop ${GREEN}command to start the VNC server.
		[-] In VNC client, enter ${ORANGE}127.0.0.1:5901 ${GREEN}as Address and Password you created to connect.	
		[-] To connect via PC over Wifi or Hotspot, use it's IP, ie: ${ORANGE}192.168.43.1:5901 ${GREEN}to connect. Also, use TigerVNC client.	
		[-] Make sure you enter the correct port. ie: If server is running on ${ORANGE}Display :2 ${GREEN}then port is ${ORANGE}5902 ${GREEN}and so on.
		[-] Optional: Install a intltool and xfce4-dev-tools after restart Usages : $(basename $0) --compile or ./compile-install.sh
	_MSG_
	{ reset_color; exit 0; }
}

## Install adb
install_adb() {
	echo -e ${GREEN}"\n[*] install ADB file..."
	echo -e ${CYAN}"\n[*] Download from github... "
	{ curl https://github.com/MasterDevX/Termux-ADB/raw/master/InstallTools.sh -o InstallTools.sh; bash InstallTools.sh; rm InstallTools.sh;}
}

## Install Visual Code
install_vsc() {
	echo -e ${GREEN}"\n[*] install Visual Sutdio Code Source..."
	{
	  wget https://packages.microsoft.com/keys/microsoft.asc -q;
	  apt-key add microsoft.asc;
	  gpg --dearmor microsoft.asc > packages.microsoft.gpg;
	  cp -rf packages.microsoft.gpg $PREFIX/etc/apt/trusted.gpg.d/
	  rm -rf microsoft.asc;
	  echo "deb https://packages.microsoft.com/repos/code stable main" > $PREFIX/etc/apt/sources.list.d/vscode.list;
	}
}

install_firefox() {
	echo -e ${GREEN}"\n[*] install Firefox (aarch64)..."
	{
	 wget http://mirror.archlinuxarm.org/aarch64/extra/firefox-89.0-1-aarch64.pkg.tar.xz -q;
	 tar -xvf firefox-89.0-1-aarch64.pkg.tar.xz;
	 cp -rf usr/ $PREFIX/;
	}
}

## Install source
install_source() {	
	echo -e ${GREEN}"\n[*] Configure sources... "
	echo -e ${CYAN}"\n[*] install source key file... "
	{
	  curl https://termux.holehan.org/holehan.key -o holehan.key;
	  curl https://hax4us.github.io/termux-x/hax4us.key -o hax4us.key;
	  curl https://dl.yarnpkg.com/debian/pubkey.gpg  -o pubkey.gpg;
	  curl https://packagecloud.io/install/repositories/swift-arm/vscode/script.deb.sh -o script.deb.sh;
	  apt-key add holehan.key;
	  apt-key add hax4us.key;
	  apt-key add pubkey.gpg;
	  rm pubkey.gpg;
	  rm hax4us.key;
	  rm holehan.key;
	  apt-key adv --keyserver pgp.mit.edu --recv A46BE53C;
	  apt-key adv --keyserver hkp://keys.gnupg.net --recv-keys 7D8D0BF6;
	  chmod +x script.deb.sh;
	}
	echo -e ${CYAN}"\n[*] Coping sources file... "
	{
	  mkdir -p $PREFIX/etc/apt/sources.list.d;
	  cp -rf $(pwd)/sources/holehan.list $PREFIX/etc/apt/sources.list.d/holehan.list;
	  cp -rf $(pwd)/sources/hax4us_x11_stable.list $PREFIX/etc/apt/sources.list.d/hax4us_x11_stable.list;
	  cp -rf $(pwd)/sources/others.list $PREFIX/etc/apt/sources.list.d/others.list;
	  bash script.deb.sh;
	}
	echo -e ${CYAN}"\n[*] Updating Termux Base... \n"
	{ reset_color; apt update; pkg update; pkg upgrade -y; }
}

## Install Termux Desktop
install_td() {
	banner
	setup_base
	install_zsh
	setup_omz
	setup_config
	setup_theme
	install_adb
	setup_vnc
	setup_launcher
	post_msg
}

install_tools_td() {
	install_source
	install_vsc
	install_firefox
	post_msg
}

compile_td() {
	banner
	echo -e ${RED}"\n[*] Compile config..."
	echo -e ${CYAN}"\n[*] Update pkg Termux Desktop..."
	{ 	reset_color; 
		pkg autoclean; 
		pkg update; 
		pkg upgrade -y; 
		pkg install perl python libexpat; 
		cpan install XML::Parser;
		cpan install XML::LibXML;
	}
	echo -e ${CYAN}"\n[*] Download, Make and install  intltool-0.51.0..."
	{	wget https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz -q;
		tar -xvf intltool-0.51.0.tar.gz;
		cd intltool-0.51.0/;
		autoreconf -fi;
		./configure --prefix=$PREFIX;
		make;
		make install;
		cd ..;
	}
	echo -e ${CYAN}"\n[*] Download, Make and install xfce4-dev-tools-4.16.0..."
	{	wget https://archive.xfce.org/src/xfce/xfce4-dev-tools/4.16/xfce4-dev-tools-4.16.0.tar.bz2 -q;
		tar -xvf xfce4-dev-tools-4.16.0.tar.bz2;
		cd xfce4-dev-tools-4.16.0/;
		autoreconf -fi;
		./configure --prefix=$PREFIX;
		make;
		make install;
		cd ..;
	}
	echo -e ${CYAN}"\n[*] install and update pip..."
	{ curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py; python get-pip.py; python -m pip install --upgrade pip ;}
	echo -e ${CYAN}"\n[*] install and update catfish..."
	{ python -m pip install --upgrade catfish; post_msg; }
}

## Uninstall Termux Desktop
uninstall_td() {
	banner
	# remove pkgs
	echo -e ${RED}"\n[*] Unistalling Termux Desktop..."
	echo -e ${CYAN}"\n[*] Removing Packages..."
	for package in "${_pkgs[@]}"; do
		echo -e ${GREEN}"\n[*] Removing Packages ${ORANGE}$package \n"
		{ reset_color; apt-get remove -y --purge --autoremove $package; }
	done
	
	# delete files
	echo -e ${CYAN}"\n[*] Deleting config files...\n"
	_homefiles=(.fehbg .icons .mpd .ncmpcpp .fonts .gtkrc-2.0 .mutt .themes .vnc Music)
	_configfiles=(Thunar geany  gtk-3.0 leafpad netsurf polybar ranger rofi xfce4)
	_localfiles=(bin lib 'share/backgrounds' 'share/pixmaps')
	for i in "${_homefiles[@]}"; do
		if [[ -f "$HOME/$i" || -d "$HOME/$i" ]]; then
			{ reset_color; rm -rf $HOME/$i; }
		else
			echo -e ${MAGENTA}"\n[!] $file Doesn't Exist.\n"
		fi
	done
	for j in "${_configfiles[@]}"; do
		if [[ -f "$HOME/.config/$j" || -d "$HOME/.config/$j" ]]; then
			{ reset_color; rm -rf $HOME/.config/$j; }
		else
			echo -e ${MAGENTA}"\n[!] $file Doesn't Exist.\n"			
		fi
	done
	for k in "${_localfiles[@]}"; do
		if [[ -f "$HOME/.local/$k" || -d "$HOME/.local/$k" ]]; then
			{ reset_color; rm -rf $HOME/.local/$k; }
		else
			echo -e ${MAGENTA}"\n[!] $file Doesn't Exist.\n"			
		fi
	done
	echo -e ${RED}"\n[*] Termux Desktop Unistalled Successfully.\n"
}

## Main
if [[ "$1" == "--install" || "$1" == "-i" ]]; then
	install_td
elif [[ "$1" == "--uninstall" ]]; then
	uninstall_td
elif [[ "$1" == "--tools" ]]; then
	install_tools_td
elif [[ "$1" == "--compile" || "$1" == "-c" ]]; then
	compile_td
else
	{ usage; reset_color; exit 0; }
fi
