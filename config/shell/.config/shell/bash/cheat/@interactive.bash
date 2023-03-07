# shellcheck shell=bash

if ! is_callable cht.sh; then
    return 1
fi

# config
export CHTSH_CURL_OPTIONS="-A curl"
export CHTSH_URL=https://cht.sh

# convenience aliases
alias ch='cht.sh'
