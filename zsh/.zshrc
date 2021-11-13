# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
PS1="%B%{$fg[red]%}<%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%m %{$fg[magenta]%}%~%{$fg[red]%}>%{$reset_color%}
%(?.&.%? &)%b "

# cross compile env
export CC_x86_64_unknown_linux_gnu=x86_64-unknown-linux-gnu-gcc
export CXX_x86_64_unknown_linux_gnu=x86_64-unknown-linux-gnu-g++
export AR_x86_64_unknown_linux_gnu=x86_64-unknown-linux-gnu-ar
export CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER=x86_64-unknown-linux-gnu-gcc

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/zsh/history


setopt no_list_ambiguous
export LANG=en_US.UTF-8
setopt autocd
setopt extended_glob

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# export NNN_PLUG='f:finder;o:fzopen;p:mocplay;d:diffs;t:nmount;v:imgview'
export NNN_PLUG='v:vidthumb'


# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"

# Custom functions for checking all listenning ports
listening() {
    if [ $# -eq 0 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P
    elif [ $# -eq 1 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
    else
        echo "Usage: listening [pattern]"
    fi
}
mglk() {
  if [ $# -eq 1 ]; then
    local res=$(curl -s "$1" -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.131 Safari/537.36'| grep -aPo "www\.rmdown\.com\/link\.php\?hash=[0-9a-zA-Z]{4,}\"" | cut -d= -f2|cut -d\" -f1|grep -Po "[0-9a-zA-Z]{40}$" | xargs -I {} echo "magnet:?xt=urn:btih:{}")
    [ "$res" = "" ] && return 1 || echo $res|tee >(pbcopy); return 0
  else
    return 1
  fi

}

# ALL my java env
JAVA_08_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_161.jdk/Contents/Home/"
JAVA_11_HOME="$(find /usr/local/Cellar/openjdk@11 -type d -name 'Home')"
JAVA_15_HOME="$(find /usr/local/Cellar/openjdk -type d -name 'Home')"
MY_SCRIPTS="$HOME/.scripts/"

CONDA_BIN_HOME="$HOME/miniconda3/bin"
export JAVA_HOME="$JAVA_11_HOME"
export ORIGIN_PATH=${ORIGIN_PATH:-$PATH}
export PATH="$JAVA_HOME"/bin:$CONDA_BIN_HOME:$MY_SCRIPTS:${ORIGIN_PATH}


function 115sha1uniq(){
  sort -t'|' -k2,4 -u "$1" | sort
}
function 115sha1size(){
  awk -F'|' '{s+=$2} END {print s}' "$1" | numfmt --to iec --format %.2f
}


source ~/.bash_profile

# This part will notify SSH service using gpg-agent instead of ssh-agent by
# default.

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

# openssl
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

# Put the line below in ~/.zshrc:
#
#   eval "$(jump shell zsh)"
#
# The following lines are autogenerated:

__jump_chpwd() {
  jump chdir
}

jump_completion() {
  reply="'$(jump hint "$@")'"
}

j() {
  local dir="$(jump cd $@)"
  test -d "$dir" && cd "$dir"
}

typeset -gaU chpwd_functions
chpwd_functions+=__jump_chpwd

compctl -U -K jump_completion j


# export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
# gpgconf --launch gpg-agent
# Load syntax highlighting; should be last.
# Because the SIP of macos, uses /usr/local/share instead of /usr/share
source /usr/local/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
