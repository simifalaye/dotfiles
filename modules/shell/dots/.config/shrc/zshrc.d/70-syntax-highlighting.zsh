#
# NOTE: This module should be loaded after all ZLE widgets have been defined.
# Namely, after the 'input' module.
#

#
# Plugin: fast-syntax-highlighting
#

# Abort if requirements are not met
(( $+functions[znap] )) || return 1
[[ -o interactive ]] || return 1

# Load plugin
znap source zdharma-continuum/fast-syntax-highlighting
