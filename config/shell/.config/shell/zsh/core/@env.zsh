# shellcheck shell=zsh

# Ensure that path arrays do not contain duplicates.
typeset -gU \
    CDPATH cdpath \
    FPATH fpath \
    MANPATH manpath \
    MODULE_PATH module_path \
    MAILPATH mailpath \
    PATH path

# Skip the not really helping Ubuntu global compinit
# NOTE: Zim will load compinit itself
skip_global_compinit=1

# Disable control flow (^S/^Q) even for non-interactive shells.
# This is useful with e.g. `tmux new-session -s foo vim`
setopt no_flow_control
