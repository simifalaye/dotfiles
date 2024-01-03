#
# The tmux app module
#

# Abort if requirements are not met
(( $+commands[bat] )) || return 1
[[ -o interactive ]] || return 1

# Figure out the TERM to use inside tmux.
if [[ $terminfo[setb24] ]]; then
  export TMUX_TERM="$TERM"
elif (( $terminfo[colors] >= 256 )); then
  export TMUX_TERM='tmux-256color'
else
  export TMUX_TERM='tmux'
fi

# Path to tmux internal dirs
export TMUX_DATA_DIR="${XDG_DATA_HOME}/tmux"
export TMUX_CACHE_DIR="${XDG_STATE_HOME}/tmux"

# Path to the tmux directory to source other configuration files.
export TMUX_CONFIG_DIR="${TMUX_CONFIG:h}"

# Convenience aliases
# shellcheck disable=SC2139
alias tmux="tmux -2 -f '${TMUX_CONFIG}'"
alias tl="tmux ls"

# Credit: https://github.com/akinsho/dotfiles/blob/main/zsh/scripts/fzf.sh
# tm [name]: Attach session or create it if it doesn't exist
#   - If no name is provided, use fzf to select one
tm() {
  [ -n "$TMUX" ] && change="switch-client" || change="attach-session"
  if [ "$1" ]; then
    tmux "$change" -t "$1" 2>/dev/null ||
      (tmux new-session -d -s "$1" && tmux "$change" -t "$1")
  elif is_callable fzf; then
    session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&
      tmux "$change" -t "$session" || echo "No sessions found."
  fi
}
