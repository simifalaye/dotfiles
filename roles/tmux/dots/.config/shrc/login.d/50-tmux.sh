# Path to the root tmux config file.
# Using this will bypass the system-wide configuration file, if any.
export TMUX_CONFIG="${XDG_CONFIG_HOME}/tmux/tmux.conf"

# Figure out the TERM to use inside tmux.
if [[ $(tput setb24 2>/dev/null) ]]; then
  export TMUX_TERM="$TERM"
elif (( $(tput colors) >= 256 )); then
  export TMUX_TERM='tmux-256color'
else
  export TMUX_TERM='tmux'
fi

# Path to tmux internal dirs
export TMUX_DATA_DIR="${XDG_DATA_HOME}/tmux"
export TMUX_CACHE_DIR="${XDG_STATE_HOME}/tmux"

# Path to the tmux directory to source other configuration files.
export TMUX_CONFIG_DIR="${TMUX_CONFIG:h}"
