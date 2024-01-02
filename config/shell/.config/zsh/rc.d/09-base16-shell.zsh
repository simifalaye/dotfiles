#
# Base16-shell terminal colors
#

# Set default theme
export BASE16_THEME_DEFAULT="gruvbox-dark-hard"

# Load repo
BASE16_SHELL="${XDG_CONFIG_HOME}/base16-shell"
if [ ! -d "${BASE16_SHELL}" ]; then
  git clone https://github.com/tinted-theming/base16-shell.git ${BASE16_SHELL}
  # Patch the profile helper to suppress the symlink output
  sed -i.bak -e '/^[[:space:]]*ln -fs/s/$/ >\/dev\/null' "${BASE16_SHELL}/profile_helper.sh"
fi

# Enable to color profile helper
if [ -n "$PS1" ] && [ -z "$SSH_TTY" ]; then
  [ -s "${BASE16_SHELL}/profile_helper.sh" ] &&
    source "${BASE16_SHELL}/profile_helper.sh"
fi

#-
#  Base16 fzf
#-

BASE16_FZF="${XDG_CONFIG_HOME}/tinted-theming/base16-fzf"

# Load repo
if [ ! -d "${BASE16_FZF}" ]; then
  git clone https://github.com/tinted-theming/base16-fzf ${BASE16_FZF}
fi