# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
        color_prompt=
    fi
fi

# The following block is surrounded by two delimiters.
# These delimiters must not be modified. Thanks.
# START KALI CONFIG VARIABLES
PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes
# STOP KALI CONFIG VARIABLES

if [ "$color_prompt" = yes ]; then
    # override default virtualenv indicator in prompt
    VIRTUAL_ENV_DISABLE_PROMPT=1

    prompt_color='\[\033[;32m\]'
    info_color='\[\033[1;34m\]'
    prompt_symbol=@
    if [ "$EUID" -eq 0 ]; then # Change prompt colors for root user
        prompt_color='\[\033[;94m\]'
        info_color='\[\033[1;31m\]'
        # Skull emoji for root terminal
        prompt_symbol=💀
    fi
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PS1=$prompt_color'┌──${debian_chroot:+($debian_chroot)──}${VIRTUAL_ENV:+(\[\033[0;1m\]$(basename $VIRTUAL_ENV)'$prompt_color')}('$info_color'\u'$prompt_symbol'\h'$prompt_color')-[\[\033[0;1m\]\w'$prompt_color']\n'$prompt_color'└─'$info_color'\$\[\033[0m\] ';;
        oneline)
            PS1='${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV)) }${debian_chroot:+($debian_chroot)}'$info_color'\u@\h\[\033[00m\]:'$prompt_color'\[\033[01m\]\w\[\033[00m\]\$ ';;
        backtrack)
            PS1='${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV)) }${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ ';;
    esac
    unset prompt_color
    unset info_color
    unset prompt_symbol
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

[ "$NEWLINE_BEFORE_PROMPT" = yes ] && PROMPT_COMMAND="PROMPT_COMMAND=echo"

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto -i'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

########## MY ADDITIONS ##########

PERSONAL_HOME_DIR="/home/eshed"

# launch nautilus with current directory shortcut
alias naupwd='nautilus $(pwd)'

# launch baobab with current directory shortcut
alias baopwd='baobab $(pwd)'

# alias clear to cls
alias cls=clear

# shortcuts to --help and --version
v='--version'
h='--help'

# alias gtext to gnome-text-editor
alias gtext=gnome-text-editor

# push with pushd the current directory
pushd() {
    if [ $# -eq 0 ]; then
        command pushd "$(pwd)"
    else
        command pushd "$@"
    fi
}

# alias that uses the 'date' command to print the current hour in H/M/S format
alias hour='date "+%H:%M:%S"'

# alias to add colors to 'less' command
alias less='less -r'

# alias tracert to traceroute
alias tracert='traceroute'

# alias uptimep to uptime -p
alias uptimep='uptime -p'

# free command aliases
alias bfree='free --bytes'
alias kfree='free --kilo'
alias mfree='free --mega'
alias gfree='free --giga'

# Directories to add
directories_to_add="/usr/local/sbin /usr/sbin /sbin $PERSONAL_HOME_DIR/.local/bin"

# Splitting the current PATH variable into an array
IFS=':' read -ra current_path <<< "$PATH"

# Flag to check if any directory needs to be added
add_flag=0

# Loop through the directories to add
for dir in $directories_to_add; do
    # Check if the directory is already in the PATH
    if [[ ":${PATH}:" != *":${dir}:"* ]]; then
        # Directory not found in PATH, add it
        PATH="${PATH}:${dir}"
        add_flag=1
    fi
done

# If any directories were added, update the PATH variable
if [[ $add_flag -eq 1 ]]; then
    export PATH
fi

alias btop='btop --utf-force'

alias aptdate="sudo apt-get update"
alias aptcheck="sudo apt-get update && apt list --upgradable"
alias aptinstall="sudo apt-get install $@"
alias aptremove="sudo apt-get purge $@"

PERSONAL_MYGITS_DIR="/home/eshed/Documents/mygits"
PERSONAL_OTHERGITS_DIR="/home/eshed/Documents/othergits"

# Activate python venv if exists in current working directory
acv() {
    if [ -d ".venv" ]; then
        echo "Activating .venv..."
        source .venv/bin/activate
    elif [ -d "venv" ]; then
        echo "Activating venv..."
        source venv/bin/activate
    else
        echo "No virtual environment found."
    fi
}

# Change directory into the my gits directory
cdm() {
	if [ "$#" -eq 0 ]; then
		cd $PERSONAL_MYGITS_DIR
	elif [ "$#" -eq 1 ]; then
		cd "$PERSONAL_MYGITS_DIR/$1"
	else
		echo "Too many parameters were given."
	fi
}

# Change directory into the other gits directory
cdo() {
    if [ "$#" -eq 0 ]; then
		cd $PERSONAL_OTHERGITS_DIR
	elif [ "$#" -eq 1 ]; then
		cd "$PERSONAL_OTHERGITS_DIR/$1"
	else
		echo "Too many parameters were given."
	fi
}

git config --global user.email "eshed.ruf@gmail.com"
git config --global user.name "Eshed Ruf"

if [ -v XDG_DATA_DIRS ]; then
	export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:/home/eshed/.local/share/flatpak/exports/share"
fi

alias blackbox-terminal="flatpak run com.raggesilver.BlackBox"

alias bat="batcat"

alias publicip="curl ifconfig.me/ip"

privateip() {
	ip_output=$(ip address)

	wifi_ip=""
	ethernet_ip=""

	interfaces=$(echo "$ip_output" | awk '/^[0-9]+:/ {print $2}' | cut -d ':' -f 1)
	for interface in $interfaces; do
		ip_addr=$(echo "$ip_output" | grep -E "inet [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | grep "$interface" | awk '{print $2}' | cut -d '/' -f 1)
		if [ -n "$ip_addr" ]; then
		    case "$interface" in
		        wlo*|wlan*) wifi_ip=$ip_addr ;;
		        en*) ethernet_ip=$ip_addr ;;
		        *) ;;
		    esac
		fi
	done

	if [ -n "$wifi_ip" ] || [ -n "$ethernet_ip" ]; then
		[ -n "$wifi_ip" ] && echo "Wifi: $wifi_ip"
		[ -n "$ethernet_ip" ] && echo "Ethernet: $ethernet_ip"
	else
		echo "disconnected"
	fi
}

# Function to get the creation date of a GitHub repository
repoc() {
	local usage="Usage: repoc <username/repository | https://github.com/username/repository | github.com/username/repository | username repository>"

    if [[ $# -eq 1 ]]; then
        local input="$1"
        local user=""
        local repo=""

        # Extract user and repo from input
        if [[ "$input" =~ ^https?://github\.com/([^/]+)/([^/]+) ]]; then
            user="${BASH_REMATCH[1]}"
            repo="${BASH_REMATCH[2]}"
        elif [[ "$input" =~ ^github\.com/([^/]+)/([^/]+) ]]; then
            user="${BASH_REMATCH[1]}"
            repo="${BASH_REMATCH[2]}"
        elif [[ "$input" =~ ^([^/]+)/([^/]+)$ ]]; then
            user="${BASH_REMATCH[1]}"
            repo="${BASH_REMATCH[2]}"
        else
            echo $usage
            return 1
        fi

    elif [[ $# -eq 2 ]]; then
        user="$1"
        repo="$2"

    else
        echo $usage
        return 1
    fi

    if [[ -z "$user" || -z "$repo" ]]; then
        echo $usage
        return 1
    fi

    local api_url="https://api.github.com/repos/$user/$repo"

    # Make an API request and extract the creation date
    creation_date=$(curl -s "$api_url" | grep -oP '"created_at": "\K[^"]+')

    if [[ -z "$creation_date" ]]; then
        echo "Failed to fetch the creation date. Please check the repository name and try again."
    else
        echo "The repository '$user/$repo' was created on: $creation_date"
    fi
}

# Copy text to clipboard
copyclip() {
    if [ "$XDG_SESSION_TYPE" = "x11" ]; then
        echo "$1" | xclip -selection clipboard
    elif [ "$XDG_SESSION_TYPE" = "wayland" ]; then
        echo "$1" | wl-copy
    else
        echo "Unknown session type. Unable to determine clipboard mechanism."
    fi
}

# Full upgrades the system
uall() {
    update_apt() {
        sudo apt-get update -y && \
        sudo apt-get dist-upgrade -y && \
        sudo apt-get autoremove --purge -y
    }

    update_pipx() {
        pipx upgrade-all
    }

    usage() {
        echo "Usage: uall [apt|pipx]"
        return 1
    }

    if [ $# -gt 1 ]; then
        usage
        return 1
    fi

    case "$1" in
        apt)
            echo -e "\n\nUpdating only APT packages:\n\n"
            update_apt
            ;;
        pipx)
            echo -e "\n\nUpdating only pipx packages:\n\n"
            update_pipx
            ;;
        "")
            echo -e "\n\nUpdating APT and pipx packages:\n\n"
            update_apt
            update_pipx
            ;;
        *)
            usage
            ;;
    esac
}

# Block a domain (and its subdomains) via dnsmasq
dnsblock() {
  if [ -z "$1" ]; then
    echo "Usage: dnsblock example.com"
    return 1
  fi
  local DOMAIN="$1"
  local ENTRY="address=/${DOMAIN}/127.0.0.1"
  if sudo grep -qxF "$ENTRY" /etc/dnsmasq.d/blocklist.conf; then
    echo "$DOMAIN is already blocked."
  else
    echo "Blocking $DOMAIN..."
    echo "$ENTRY" | sudo tee -a /etc/dnsmasq.d/blocklist.conf >/dev/null
    sudo systemctl restart dnsmasq && echo "dnsmasq reloaded."
  fi
}

# Unblock a domain
dnsunblock() {
  if [ -z "$1" ]; then
    echo "Usage: dnsunblock example.com"
    return 1
  fi
  local DOMAIN="$1"
  local ENTRY="address=/${DOMAIN}/127.0.0.1"
  if sudo grep -qxF "$ENTRY" /etc/dnsmasq.d/blocklist.conf; then
    echo "Unblocking $DOMAIN..."
    sudo sed -i "\|$ENTRY|d" /etc/dnsmasq.d/blocklist.conf
    sudo systemctl restart dnsmasq && echo "dnsmasq reloaded."
  else
    echo "$DOMAIN is not currently blocked."
  fi
}

# List currently blocked domains
dnslist() {
  grep -E '^address=/.*?/127\.0\.0\.1' /etc/dnsmasq.d/blocklist.conf || echo "No entries in blocklist."
}


discord_path="/usr/share/discord/resources/build_info.json"

if [ -d "$PERSONAL_HOME_DIR/.cargo" ]; then
	. "$PERSONAL_HOME_DIR/.cargo/env"
fi

