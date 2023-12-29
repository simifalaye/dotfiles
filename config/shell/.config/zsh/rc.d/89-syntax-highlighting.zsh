#
# Plugin: zsh-syntax-highlighting
#
# NOTE: This module should be loaded after all ZLE widgets have been defined.
# Namely, after the 'input' module.
#

# Abort if requirements are not met
(( $+functions[znap] )) || return 1

# `znap source` starts plugins.
znap source zsh-users/zsh-syntax-highlighting
