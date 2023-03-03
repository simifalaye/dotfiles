# shellcheck disable=SC2148
source "${HOME}/.config/shell/posix/env.sh"

#-
#  Options
#-

# Ensure that path arrays do not contain duplicates.
typeset -gU \
    CDPATH cdpath \
    FPATH fpath \
    MANPATH manpath \
    MODULE_PATH module_path \
    MAILPATH mailpath \
    PATH path

# Skip the not really helping Ubuntu global compinit
skip_global_compinit=1
