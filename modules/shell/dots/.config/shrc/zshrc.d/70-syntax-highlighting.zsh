#
# NOTE: This module should be loaded after all ZLE widgets have been defined.
# Namely, after the 'input' module.
#

#
# Plugin: zsh-syntax-highlighting
#

# Abort if requirements are not met
(( $+functions[znap] )) || return 1
[[ -o interactive ]] || return 1

# Set highlighters
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

#Load plugin
znap source zsh-users/zsh-syntax-highlighting
