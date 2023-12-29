#
# Plugin: zsh-completions -- Extra app completion definitions
#

# Abort if requirements are not met.
(( $+functions[znap] )) || return 1

# `znap install` adds new commands and completions.
znap install zsh-users/zsh-completions
