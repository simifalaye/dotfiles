# shellcheck shell=bash

if ! is_callable trash; then
  return 1
fi

# Remove files that have been trashed more than 30 days ago
if [ -z "$TMUX" ]; then
  trash-empty 30
fi
