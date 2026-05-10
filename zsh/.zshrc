# ── Path ──────────────────────────────────────────────────────────────────────
export PATH=$HOME/bin:/usr/local/bin:$HOME/.symfony5/bin:$HOME/.local/bin:$PATH

# ── Oh-my-zsh ─────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
# ZSH_THEME="agnoster"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086"

# ── History ───────────────────────────────────────────────────────────────────
HIST_STAMPS="yyyy-mm-dd"

# ── pnpm ──────────────────────────────────────────────────────────────────────
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# ── nvm ───────────────────────────────────────────────────────────────────────
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# ── fzf ───────────────────────────────────────────────────────────────────────
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ── zoxide ────────────────────────────────────────────────────────────────────
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# ── direnv ────────────────────────────────────────────────────────────────────
export DIRENV_LOG_FORMAT=""
eval "$(direnv hook zsh)"

# ── Secrets (not tracked) ─────────────────────────────────────────────────────
[ -f ~/.zshrc.secrets ] && source ~/.zshrc.secrets

# ── Aliases ───────────────────────────────────────────────────────────────────
alias g="git"
alias grep="grep -i --color"
alias :q="exit"
alias global_ip="curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'"
alias local_ip="ip addr | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
alias randPass="head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13; echo ''"
alias {c,clr,ckear,cler,clar,clearr,clqar}="clear"

# ── Functions ─────────────────────────────────────────────────────────────────
my-backward-delete-word() {
  local WORDCHARS=${WORDCHARS/\//}
  zle backward-delete-word
}
zle -N my-backward-delete-word
bindkey '^W' my-backward-delete-word

vf() { fzf | xargs -r -I % ${EDITOR:-vim} % ; }

man() {
  local width=$(tput cols)
  [ $width -gt ${MANWIDTH:-120} ] && width=${MANWIDTH:-120}
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
