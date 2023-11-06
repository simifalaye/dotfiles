# shellcheck shell=bash
#
# Tmux configuration module
#

# Abort if requirements are not met
if ! is_callable tmux; then
  return 1
fi

# Setup copy command for wsl
if is_wsl; then
  export TMUX_CLIPBOARD="clip.exe"
fi

# Convenience aliases
# shellcheck disable=SC2139
alias tmux="tmux -2 -f '${HOME}/.config/tmux/tmux.conf'"
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
