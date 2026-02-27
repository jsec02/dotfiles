# ================================================================================
# =                                    .ZSHRC                                    =
# ================================================================================

setopt autocd # cd into dirs without typing cd
setopt correct # Suggest corrections for mistyped commands

[[ $- != *i* ]] && return # If not running interactively, don't do anything

eval "$(direnv hook zsh)" # Initialize direnv

eval "$(zellij setup --generate-auto-start zsh)" # Automatically start zellij

PROMPT_EOL_MARK="" # hide EOL sign ('%')


# ==================================== PROMPT ====================================


export VIRTUAL_ENV_DISABLE_PROMPT=1

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


# =============================== AUTO-SUGGESTIONS ===============================


source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'


# ==================================== ZELLIJ ====================================


if command -v zellij &>/dev/null; then
    eval "$(zellij setup --generate-auto-start zsh)"
    precmd() {
        print -Pn "\e]0;%n@%m:%~\a"
    }
fi


# =================================== ALIASES ====================================


# General
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias weather='curl wttr.in'

# nvim
alias lvim='NVIM_APPNAME=nvim.lazy nvim'
alias avim='NVIM_APPNAME=nvim.astro nvim'
alias mvim='NVIM_APPNAME=nvim.mini nvim'

# VirtualBox
alias vbox='"/mnt/c/Program Files/Oracle/VirtualBox/VBoxManage.exe"'

# Projects
alias alien_invasion='cd ~/python/projects/alien_invasion'
alias data_visualization='cd ~/python/projects/data_visualization/'
alias dotfiles='cd ~/dotfiles/'
alias neovim='cd ~/.config/nvim/'
alias fish_tank='cd ~/python/projects/fish_tank/'
alias riven_sniper='cd ~/python/projects/riven_sniper/'
alias wfm='cd ~/python/projects/wfm/'
alias port_scanner='cd ~/python/projects/port_scanner/'
alias pping='cd ~/python/projects/ping/'

# Show project aliases
projects() {
  echo "Available projects:"
  alias | grep "cd ~" | sed "s/alias /  /" | sed "s/='cd /  -> /" | sed "s/'$//" | sort
}


# ============================ ENVIRONMENT VARIABLES =============================


# Load secrets
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# General
export EDITOR=nvim
export BROWSER="/mnt/c/Program Files/Mozilla Firefox/firefox.exe" # Use windows browser

# Path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/python/scripts/:$PATH"
export PATH="$HOME/bash/scripts/:$PATH"
export PATH="$HOME/bash/backup/scripts/:$PATH"

# Python
export PYTHONPATH="$HOME/python/modules:$PYTHONPATH"
export PYTHONBREAKPOINT=ipdb.set_trace

# VcXsrv
export DISPLAY=$(ip route show default | awk '{print $3}'):0.0
export LIBGL_ALWAYS_INDIRECT=1


# =================================== KEYMAPS ====================================


bindkey '^R' history-incremental-search-backward


# =================================== HISTORY ====================================


# History file location
export HISTFILE=~/.zsh_history

# Increase history size
export HISTSIZE=100000
export SAVEHIST=100000

# Zsh history options
setopt HIST_IGNORE_DUPS      # Don't record duplicate commands
setopt HIST_IGNORE_SPACE     # Don't record commands starting with space
setopt SHARE_HISTORY         # Share history across all sessions


# =================================== PLUGINS ====================================


# git clone https://github.com/hlissner/zsh-autopair ~/.zsh/zsh-autopair
source ~/.zsh/zsh-autopair/autopair.zsh


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
