# shellcheck disable=SC2148
# vim: filetype=bash
#
# This file is sourced by `bash` non-login interactive shells.
# It is read after /etc/bash.bashrc.
#

[ -r "${HOME}/.config/shell/bash/env.bash" ] && . "${HOME}/.config/shell/bash/env.bash"
[ -r "${HOME}/.config/shell/bash/interactive.bash" ] && . "${HOME}/.config/shell/bash/interactive.bash"
