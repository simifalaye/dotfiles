#
# The lazygit module
#

# Abort if requirements are not met
(( $+commands[lazygit] )) || return 1
[[ -o interactive ]] || return 1

# Aliases
alias lg='lazygit'
