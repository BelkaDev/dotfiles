# If you come from bash you might have to change your $PATH.

# Paths
export PATH=$HOME/bin:/usr/local/bin:$PATH
export MANPATH="/usr/local/man:$MANPATH"
export ZSH=$HOME/.oh-my-zsh
# Directory to encrypt password with vim-gpg
#export PASSWD=~/.passwords

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

# Uncomment the following line to display red dots whilst waiting for completion.
 COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# Update Dmenu options and theme
# source dmenu.conf

# Rofi Askpass
# export SUDO_ASKPASS=$HOME/.local/bin/rofi-askpass

# Dictionary
export STARDICT_DATA_DIR=~/.conf/sdcv

# Credentials & Secret Keys
export SPOTIFY_USER=""
export SPOTIFY_PWD=""
export LASTFM_SECRET_KEY=""
export GOOGLE_SECRET_KEY=""

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='subl'
 else
   export EDITOR='subl'
 fi

# Snippets 
my-backward-delete-word() {
    local WORDCHARS=${WORDCHARS/\//}
    zle backward-delete-word
}
zle -N my-backward-delete-word
bindkey '^W' my-backward-delete-word
reminder () { sleep $1 && notify-send -u critical -i clock $2 }
vf() { fzf | xargs -r -I % $EDITOR % ;}
pause () { node /home/belka/docs/projects/spotifyjwt/src/play_pause.js }
search() { node /home/belka/docs/projects/spotifyjwt/src/search $* }
queue() { 
if [[ "$1" = "on" ]];  then
shift
node /home/belka/docs/projects/spotifyjwt/src/play $(on $*)
else
node /home/belka/docs/projects/spotifyjwt/src/play "$*"
fi
}
on() { node /home/belka/docs/projects/spotifyjwt/src/transfer $(node /home/belka/docs/projects/spotifyjwt/src/connectedDevices $1)
}
parse() {
  __trim() {
echo "$1" | sed -e 's/\[[^][]*\]//g' | sed -e 's/([^()]*)//g'
}
vid=$(youtube-dl -i --get-title --skip-download --quiet --no-warnings --ignore-errors "$1" 2>/dev/null) 
printf "$(__trim "$vid")"
}

# Aliases
alias pl='perl'
alias py='python'
alias g="git"
alias def="/usr/bin/sdcv"
alias lsp="pacman -Qett --color=always | less"
alias e="$EDITOR"
alias k="pkill"
alias fierce=python fierce/fierce.py
alias sxiv="sxiv -a"
alias sudo="sudo -A"
alias grep="grep -i --color"
alias :q="exit"
alias global_ip="curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'"
alias local_ip="ip addr | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
alias yt="youtube-viewer"
alias ytMusic="youtube-dl --extract-audio --audio-format mp3"
alias randPass="head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''"
alias pkgByDate="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort"
alias {c,clr,ckear,cler,clar,clearr,clqar,cleara,cleaqr}="clear"
alias ~='urxvtc' #Open new terminals in current working directory

# Page up (and <C-b> in vicmd).
bindkey -M vicmd $terminfo[kpp] beginning-of-buffer-or-history

# Page down (and <C-f> in vicmd).
bindkey -M vicmd $terminfo[knp] end-of-buffer-or-history


# Colored manpages
man() {
   local width=$(tput cols) 
   [ $width -gt $MANWIDTH ] && width=$MANWIDTH
   env MANWIDTH=$width \
   LESS_TERMCAP_mb=$'\E[01;31m' \
   LESS_TERMCAP_md=$'\E[01;38;5;74m' \
   LESS_TERMCAP_me=$'\E[0m' \
   LESS_TERMCAP_se=$'\E[0m' \
   LESS_TERMCAP_so=$'\E[38;5;246m' \
   LESS_TERMCAP_ue=$'\E[0m' \
   LESS_TERMCAP_us=$'\E[04;38;5;146m' \
   man "$@"
}


# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
[[ -f /tmp/yay/httptoolkit/src/httptoolkit/node_modules/tabtab/.completions/electron-forge.zsh ]] && . /tmp/yay/httptoolkit/src/httptoolkit/node_modules/tabtab/.completions/electron-forge.zsh

# cd without typing cd
shopt -s autocd