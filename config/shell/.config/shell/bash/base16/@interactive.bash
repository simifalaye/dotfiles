# shellcheck shell=bash

BASE16_SHELL="${XDG_CONFIG_HOME}/base16-shell"

# Load repo
if [ ! -d "${BASE16_SHELL}" ]; then
  git clone https://github.com/chriskempson/base16-shell ${BASE16_SHELL}
fi

# Enable to color profile helper
if [ -n "$PS1" ]; then
  [ -s "${BASE16_SHELL}/profile_helper.sh" ] && source "${BASE16_SHELL}/profile_helper.sh"
fi
