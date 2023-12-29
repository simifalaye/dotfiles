#
# Plugin: zsh-vi-mode.zsh -- A better and friendly vi(vim) mode for Zsh
#
# NOTE: This module wraps zle widgets so it should come after the 'input' module
#

# Abort if requirements are not met
(( $+functions[znap] )) || return 1

# `znap source` starts plugins.
znap source jeffreytse/zsh-vi-mode
