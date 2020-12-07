# vim: filetype=zsh

# Description
# ===========
# This file is sourced by `zsh` login shells.
# It is read after ~/.zshenv and /etc/zsh/zprofile.

# Load shell common
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/login"

# Set vendor completions path
fpath=(/usr/share/zsh/vendor-completions/ $fpath)
