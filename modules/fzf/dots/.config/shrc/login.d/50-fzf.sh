# Setup basic options
export FZF_DEFAULT_OPTS='
--reverse
--no-mouse
--cycle
--layout=default
--bind ctrl-h:backward-kill-word
--bind ctrl-u:clear-query
--bind ctrl-k:kill-line
--bind ctrl-space:toggle-out
--bind ctrl-a:toggle-all'

# Use fd if available
if command -v fd >/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
  export FZF_FILES_COMMAND="${FZF_DEFAULT_COMMAND} --type f"
  export FZF_DIRS_COMMAND="${FZF_DEFAULT_COMMAND} --type d"
fi

