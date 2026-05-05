# ================================================================================
# =                                    .ZSHRC                                    =
# ================================================================================

[[ $- != *i* ]] && return # Exit early if not running interactively

# Set default mask
umask 022

# cd into dirs without typing cd
setopt autocd

# Suggest corrections for mistyped commands
setopt correct

# Stop zsh from stripping trailing slashes
setopt NO_AUTO_REMOVE_SLASH

# Free up ctrl+s for incremental search
stty -ixon

# If on x11, decrease key repeat delay and increase key repeat speed respectively
[[ "$XDG_SESSION_TYPE" == "x11" ]] && xset r rate 250 30

# Hide EOL sign ('%')
PROMPT_EOL_MARK=""

# Set terminal title with zsh hook
precmd() {
    print -Pn "\e]0;%n@%m:%~\a"
}

# ==================================== PROMPT ====================================

# Disable default venv display
VIRTUAL_ENV_DISABLE_PROMPT=1

setopt prompt_subst
PROMPT='%F{white}╭─%f${VIRTUAL_ENV:+($(basename "$VIRTUAL_ENV")) }%B%F{green}%n@%m%f%b %B%F{12}%~%f%b
%F{white}╰─$%f '

# ================================= COMPLETIONS ==================================

autoload -Uz compinit

compinit -d ~/.cache/zcompdump

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*:descriptions' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# ==================================== DIRENV ====================================

if command -v direnv &>/dev/null; then
    eval "$(direnv hook zsh)" # Hook direnv into precmd to auto-load .envrc files
fi

# ==================================== ZELLIJ ====================================

if command -v zellij &>/dev/null && [[ -z $SSH_CLIENT ]]; then
    eval "$(zellij setup --generate-auto-start zsh)" # Start zellij automatically
fi

# =================================== ALIASES ====================================

# General
alias grep='grep --color=auto'
alias weather='curl wttr.in'

# ls
if command -v dircolors &>/dev/null; then
    eval "$(dircolors --bourne-shell)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # Change world-writable dir colors
    alias ls='ls --color=auto'
fi

# History
alias history="history 0"

# Auto suggestions
alias suggestoff='ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=0'
alias suggeston='unset ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE'

# nvim
alias lvim='NVIM_APPNAME=nvim.lazy nvim'
alias avim='NVIM_APPNAME=nvim.astro nvim'
alias mvim='NVIM_APPNAME=nvim.mini nvim'

# Backup
[[ $HOST == "wsl" ]] && alias backupall='backup && ssh pi backup && ssh kali backup'

# VirtualBox
[[ -e "/mnt/c/Program Files/Oracle/VirtualBox/VBoxManage.exe" ]] \
    && alias vbox='"/mnt/c/Program Files/Oracle/VirtualBox/VBoxManage.exe"'

# Vault
alias documentation='cd $HOME/vault/documentation'
alias educational='cd $HOME/vault/educational'
alias personal='cd $HOME/vault/personal'
alias professional='cd $HOME/vault/professional'
alias pentesting='cd $HOME/vault/pentesting'

# ===================================== VPN ======================================

# Assumes single .conf in /etc/wireguard/ and uses its name for wg-quick
if command -v wg-quick &>/dev/null; then
    vpnon() {
        local conf=$(sudo ls /etc/wireguard/ 2>/dev/null | xargs basename --suffix=.conf)
        sudo wg-quick up $conf
    }

    vpnoff() {
        local conf=$(sudo ls /etc/wireguard/ 2>/dev/null | xargs basename --suffix=.conf)
        sudo wg-quick down $conf
    }
fi

# ===================================== MAN ======================================

if command -v nvim &>/dev/null; then
    export MANPAGER='nvim +Man!' # Use nvim as manpager

    man() {
        MANWIDTH=$(( COLUMNS - 3 )) command man "$@" # Fix manpage centering in nvim
    }
fi

# =================================== HISTORY ====================================

# History file location
export HISTFILE=~/.zsh_history

# Increase history size
export HISTSIZE=100000
export SAVEHIST=100000

# Zsh history options
setopt HIST_IGNORE_DUPS # Don't record duplicate commands
setopt HIST_IGNORE_SPACE # Don't record commands starting with space
setopt SHARE_HISTORY # Share history across all sessions

# ===================================== GIT ======================================

gitpush() {
    local dir="$1"
    local msg="$2"

    (cd "$dir" && git add . && git commit -m "$msg" && git push)
}

if [[ $HOST == "wsl" ]]; then
    giteducational() { gitpush "$HOME/vault/educational" "update $(date +%Y-%m-%d)"; }
    gitpentesting() { gitpush "$HOME/vault/pentesting" "update $(date +%Y-%m-%d)"; }
    gitspellfile() { gitpush "$HOME/.config/nvim/spell" "chore: update spellfiles"; }
fi

# ================================ ABBREVIATIONS =================================

typeset -Ag abbreviations

abbreviations=(
    [feat]='git commit -m "feat:'
    [fix]='git commit -m "fix:'
    [docs]='git commit -m "docs:'
    [style]='git commit -m "style:'
    [refactor]='git commit -m "refactor:'
    [test]='git commit -m "test:'
    [chore]='git commit -m "chore:'
)

magic-abbrev-expand() {
    local word=${LBUFFER##* }
    local expansion=${abbreviations[$word]}

    if [[ -n $expansion ]]; then
        LBUFFER=${LBUFFER%$word}$expansion # Strip word from end, append expansion
        RBUFFER='"'$RBUFFER  # Add closing quote to right buffer
    fi

    zle self-insert
}

no-magic-abbrev-expand() {
  LBUFFER+=' '
}

# Register functions to zle widgets
zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand

bindkey " " magic-abbrev-expand
bindkey "^ " no-magic-abbrev-expand

# ================================================================================
# =                                    ZINIT                                     =
# ================================================================================

# If zinit is missing, install it
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

# Load zinit
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# ============================= ZSH-AUTOSUGGESTIONS ==============================

zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

# ================================= ZSH-VI-MODE ==================================

zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# If TERM is vte-256color, override cursor shape since it blocks zsh-vi-mode's sequences
# TERM may be set to vte-256color to make undercurls work in zellij
if [[ "$TERM" == "vte-256color" ]]; then
    zvm_after_select_vi_mode() {
      case $ZVM_MODE in
        $ZVM_MODE_NORMAL)
          echo -ne '\e[1 q' # block cursor
        ;;
        $ZVM_MODE_INSERT)
          echo -ne '\e[5 q' # beam cursor
        ;;
      esac
    }
fi
