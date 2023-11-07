# shellcheck shell=bash

#-
#  Base16 main repo
#-

# Set default theme
export BASE16_THEME_DEFAULT="gruvbox-dark-hard"

# Load repo
BASE16_SHELL="${XDG_CONFIG_HOME}/base16-shell"
if [ ! -d "${BASE16_SHELL}" ]; then
	git clone https://github.com/tinted-theming/base16-shell.git ${BASE16_SHELL}
fi

# Enable to color profile helper
[ -n "$PS1" ] &&
	[ -s "${BASE16_SHELL}/profile_helper.sh" ] &&
	source "${BASE16_SHELL}/profile_helper.sh" | grep -v '\->' || true # Remove symlink output

#-
#  Base16 fzf
#-

BASE16_FZF="${XDG_CONFIG_HOME}/tinted-theming/base16-fzf"

# Load repo
if [ ! -d "${BASE16_FZF}" ]; then
	git clone https://github.com/tinted-theming/base16-fzf ${BASE16_FZF}
fi

#-
#  Delta
#-

export BASE16_SHELL_ENABLE_VARS=1
