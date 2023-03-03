# shellcheck disable=SC2148
# vim: filetype=bash
#
# This file is sourced by `bash` login shells.
# It is read after /etc/profile.
#

[ -r "${HOME}/.config/shell/bash/env.bash" ] && . "${HOME}/.config/shell/bash/env.bash"
[ -r "${HOME}/.config/shell/bash/login.bash" ] && . "${HOME}/.config/shell/bash/login.bash"

# Bash does not read ~/.bashrc in a login shell even if it is interactive.
if [[ $- == *i* ]]; then
    [ -r "${HOME}/.config/shell/bash/interactive.bash" ] && . "${HOME}/.config/shell/bash/interactive.bash"
fi
