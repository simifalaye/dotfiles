# vim: filetype=zsh

# Description
# ===========
# This is the first user configuration entry point for any running zsh
# shell session. This file is always sourced:
# +-----------------+-----------+-----------+------+
# |                 |Interactive|Interactive|Script|
# |                 |login      |non-login  |      |
# +-----------------+-----------+-----------+------+
# |~/.zshenv        |    y      |    y      |  y   |
# +-----------------+-----------+-----------+------+
# |$ZDOTDIR/.zshrc  |    y      |    y      |  n   |
# +-----------------+-----------+-----------+------+
# |$ZDOTDIR/.zlogout|    y      |    n      |  n   |
# +-----------------+-----------+-----------+------+

# Load shell common
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/env"

# Move ZDOTDIR from $HOME to reduce dotfile pollution.
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE="$XDG_CACHE_HOME/zsh"
