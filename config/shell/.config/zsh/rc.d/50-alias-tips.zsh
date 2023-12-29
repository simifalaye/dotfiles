#
# Plugin: alias-tips -- Reminder about aliases
#

# Abort if requirements are not met
(( $+functions[znap] )) || return 1

# `znap source` starts plugins.
znap source djui/alias-tips
