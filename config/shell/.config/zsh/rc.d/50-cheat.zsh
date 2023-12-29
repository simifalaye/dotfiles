#
# The cht.sh module
#

# Abort if requirements are not met
(( $+commands[cht.sh] )) || return 1
[[ -o interactive ]] || return 1

# Config
export CHTSH_CURL_OPTIONS="-A curl"
export CHTSH_URL=https://cht.sh

# Aliases
alias ch='cht.sh'
