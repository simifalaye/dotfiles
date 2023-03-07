# shellcheck shell=bash

if ! is_callable zoxide; then
    return 1
fi

# Config
export _ZO_ECHO=1

# Startup zoxide
eval "$(zoxide init posix --no-cmd --hook prompt)"

# Replace aliases with j (jump)
# NOTE: Required is loading on zsh and using z-shell/zi plugin manager
alias j='__zoxide_z'
alias ji='__zoxide_zi'
