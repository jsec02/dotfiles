# ================================================================================
# =                                   .ZSHENV                                    =
# ================================================================================

# Set default umask
umask 022

# Only add to PATH if not already present
typeset -U PATH path

# Load secrets
[ -f ~/.zshenv.local ] && source ~/.zshenv.local

# General
export EDITOR=nvim
export BROWSER="/mnt/c/Program Files/Mozilla Firefox/firefox.exe" # Use windows browser

# Path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/python/scripts:$PATH"
export PATH="$HOME/bash/scripts:$PATH"
export PATH="$HOME/bash/backup/scripts:$PATH"

# Python
export PYTHONBREAKPOINT=ipdb.set_trace
