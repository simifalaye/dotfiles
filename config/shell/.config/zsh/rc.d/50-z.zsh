#
# Plugin: zsh-z -- Jump to commonly accessed directories
#

# Abort if requirements are not met
(( $+functions[znap] )) || return 1

# Config
export ZSHZ_DATA="${ZCACHEDIR}/z"

# `znap source` starts plugins.
znap source agkozak/zsh-z
