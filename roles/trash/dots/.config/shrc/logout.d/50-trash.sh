# Remove files that have been trashed more than 30 days ago
if [ -z "$TMUX" ]; then
  trash-empty -f 30
fi
