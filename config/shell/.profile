# shellcheck disable=SC2148
# vim: filetype=sh
#
# This file is sourced by `dash`, `ash` and more generally by `sh` login shells,
# regardless of the underlying implementation.
# It is read after /etc/profile.
#

[ -r "${HOME}/.config/shell/posix/env.sh" ] && . "${HOME}/.config/shell/posix/env.sh"
[ -r "${HOME}/.config/shell/posix/login.sh" ] && . "${HOME}/.config/shell/posix/login.sh"
