#
# The bat module
#

# Abort if requirements are not met
(( $+commands[bat] )) || return 1
[[ -o interactive ]] || return 1

export BAT_PAGER='less -F'
alias cat="bat -p"
