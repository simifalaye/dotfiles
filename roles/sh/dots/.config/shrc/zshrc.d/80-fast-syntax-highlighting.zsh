#
# NOTE: This module should be loaded after all ZLE widgets have been defined.
# Namely, after the 'input' module.
#

[[ -o interactive ]] || return 0

#
# fast-syntax-highlighting plugin
#

# Load plugin
znap source zdharma-continuum/fast-syntax-highlighting
