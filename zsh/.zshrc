# ================================================================================
# =                                    .ZSHRC                                    =
# ================================================================================

setopt autocd # cd into dirs without typing cd
setopt correct # Suggest corrections for mistyped commands

[[ $- != *i* ]] && return # If not running interactively, don't do anything

# If on x11, decrease key repeat delay and increase key repeat speed respectively
[[ "$XDG_SESSION_TYPE" == "x11" ]] && xset r rate 250 30

PROMPT_EOL_MARK="" # Hide EOL sign ('%')

precmd() {
    print -Pn "\e]0;%n@%m:%~\a" # Terminal title
}

# ==================================== PROMPT ====================================

VIRTUAL_ENV_DISABLE_PROMPT=1 # Disable default venv display

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
    eval "$(direnv hook zsh)"
fi

# ==================================== ZELLIJ ====================================

# Start zellij automatically
if command -v zellij &>/dev/null; then
    eval "$(zellij setup --generate-auto-start zsh)"
fi

# =================================== ALIASES ====================================

# General
alias grep='grep --color=auto'
alias weather='curl wttr.in'

# ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:"
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

# git
alias gitvault='git add . && git commit -m "update $(date +%Y-%m-%d)" && git push'

# VirtualBox
alias vbox='"/mnt/c/Program Files/Oracle/VirtualBox/VBoxManage.exe"'

# VPN
alias vpnon='sudo wg-quick up "$HOSTNAME"'
alias vpnoff='sudo wg-quick down "$HOSTNAME"'

# Vault
alias documentation='cd ~/vault/documentation/'
alias educational='cd ~/vault/educational/'
alias personal='cd ~/vault/personal/'
alias professional='cd ~/vault/professional/'

# Projects
alias alien_invasion='cd ~/python/projects/alien_invasion'
alias data_visualization='cd ~/python/projects/data_visualization'
alias dotfiles='cd ~/dotfiles'
alias neovim='cd ~/.config/nvim'
alias fish_tank='cd ~/python/projects/fish_tank'
alias riven_sniper='cd ~/python/projects/riven_sniper'
alias wfm='cd ~/python/projects/wfm'
alias port_scanner='cd ~/python/projects/port_scanner'
alias pping='cd ~/python/projects/ping'

# Show project aliases
projects() {
  echo "Available projects:"
  alias | grep "cd ~" | sed "s/alias /  /" | sed "s/='cd /  -> /" | sed "s/'$//" | sort
}

# ================================== MAN PAGES ===================================

export MANPAGER='nvim +Man!'
man() {
    MANWIDTH=$(( COLUMNS - 3 )) command man "$@" # Fix manpage centering in nvim
}

# =================================== VI MODE ====================================

bindkey -v

KEYTIMEOUT=1 # Reduce escape key delay for mode switching

# Fix backspace not working after switching modes
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char

# History keymaps
bindkey -M vicmd '/' history-incremental-search-backward
bindkey -M vicmd '?' history-incremental-search-forward

# Cursor shape based on mode
function zle-keymap-select {
  if [[ $KEYMAP == vicmd ]]; then
    echo -ne '\e[1 q' # block cursor (normal mode)
  else
    echo -ne '\e[5 q' # beam cursor (insert mode)
  fi
}

zle-line-init() {
    zle -K viins  # insert mode
    echo -ne '\e[5 q' # beam cursor
}

zle -N zle-keymap-select
zle -N zle-line-init

# Clipboard integration
if command -v wl-copy &>/dev/null; then
    function _clip_copy() { wl-copy }

    function _vi-yank-clip()            { zle vi-yank;           echo -n "$CUTBUFFER" | _clip_copy }
    function _vi-yank-eol-clip()        { zle vi-yank-eol;       echo -n "$CUTBUFFER" | _clip_copy }
    function _vi-yank-whole-line-clip() { zle vi-yank-whole-line; echo -n "$CUTBUFFER" | _clip_copy }
    function _vi-delete-clip()          { zle vi-delete;         echo -n "$CUTBUFFER" | _clip_copy }
    function _vi-change-clip()          { zle vi-change;         echo -n "$CUTBUFFER" | _clip_copy }

    zle -N _vi-yank-clip
    zle -N _vi-yank-eol-clip
    zle -N _vi-yank-whole-line-clip
    zle -N _vi-delete-clip
    zle -N _vi-change-clip

    bindkey -M vicmd 'y'  _vi-yank-clip
    bindkey -M vicmd 'Y'  _vi-yank-eol-clip
    bindkey -M vicmd 'yy' _vi-yank-whole-line-clip
    bindkey -M vicmd 'd'  _vi-delete-clip
    bindkey -M vicmd 'c'  _vi-change-clip
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
setopt HIST_IGNORE_SPACE # Prefix commands with space to exclude from history

# =================================== PLUGINS ====================================

# zsh-autosuggestions
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

# ================================ ABBREVIATIONS =================================

typeset -Ag abbreviations
abbreviations=(
  "feat"     'git commit -m "feat:'
  "fix"      'git commit -m "fix:'
  "docs"     'git commit -m "docs:'
  "style"    'git commit -m "style:'
  "refactor" 'git commit -m "refactor:'
  "test"     'git commit -m "test:'
  "chore"    'git commit -m "chore:'
)

magic-abbrev-expand() {
  local word=${LBUFFER##* }
  local expansion=${abbreviations[$word]}

  if [[ -n $expansion ]]; then
    LBUFFER=${LBUFFER%$word}$expansion
    RBUFFER='"'$RBUFFER  # Add closing quote to right buffer
  fi

  zle self-insert
}

no-magic-abbrev-expand() {
  LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
bindkey " " magic-abbrev-expand
bindkey "^ " no-magic-abbrev-expand
