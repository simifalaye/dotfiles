# shellcheck shell=bash
#
# Tmux configuration module
#

# Abort if requirements are not met
if ! is_callable tmux; then
  return 1
fi

# Path to the root tmux config file.
# Using this will bypass the system-wide configuration file, if any.
export TMUX_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"
