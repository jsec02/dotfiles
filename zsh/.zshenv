# ================================================================================
# =                                   .ZSHENV                                    =
# ================================================================================

# Set default umask
umask 022

# Only add to PATH if not already present
typeset -U PATH path

# Load secrets
[[ -f "$HOME/.zshenv.local" ]] && source "$HOME/.zshenv.local"

# General
if command -v nvim &>/dev/null; then
    export EDITOR=nvim
fi

# Path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export PATH="$HOME/python/scripts:$PATH"
export PATH="$HOME/bash/scripts:$PATH"
export PATH="$HOME/bash/backup:$PATH"
export PATH="$PATH:/mnt/c/Windows/System32"

# Python
export PYTHONBREAKPOINT=ipdb.set_trace
