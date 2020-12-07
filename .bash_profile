# vim: filetype=bash

# Description
# ===========
# This file is sourced by `bash` login shells.
# It is read after /etc/profile.

# Load shell common
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/env"
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/login"
