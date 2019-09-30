# Description
# ===========
# This is the first user configuration entry point for any running zsh
# shell session. This file is always sourced:
# +----------------+-----------+-----------+------+
# |                |Interactive|Interactive|Script|
# |                |login      |non-login  |      |
# +----------------+-----------+-----------+------+
# |~/.zshenv       |    y      |    y      |  y   |
# +----------------+-----------+-----------+------+
# |$ZDOTDIR/.zshrc |    y      |    y      |  n   |
# +----------------+-----------+-----------+------+
# |$ZDOT../.zlogout|    y      |    n      |  n   |
# +----------------+-----------+-----------+------+

# Source global definitions
test -r ~/.config/shell/shell-profile && . ~/.config/shell/shell-profile

# Move ZDOTDIR from $HOME to reduce dotfile pollution.
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZGEN_DIR="$XDG_CACHE_HOME/zgen"
export ZSH_CACHE="$XDG_CACHE_HOME/zsh"

# Set vendor completions path
fpath=(/usr/share/zsh/vendor-completions/ $fpath)
