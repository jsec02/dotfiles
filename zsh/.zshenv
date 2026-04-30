# ================================================================================
# =                                   .ZSHENV                                    =
# ================================================================================

# Load secrets
[[ -f "$HOME/.zshenv.local" ]] && source "$HOME/.zshenv.local"

# General
if command -v nvim &>/dev/null; then
    export EDITOR=nvim
fi

# Python
export PYTHONBREAKPOINT=ipdb.set_trace
