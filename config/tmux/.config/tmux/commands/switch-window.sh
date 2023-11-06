#!/bin/sh
#
# Reload the tmux configuration.
#

# Define the alias for this command.
if [ -n "$TMUX_COMMAND_LOAD" ]; then
  tmux set "command-alias[$TMUX_COMMAND_LOAD]" switch-window="run '$0'"
  return
fi

tmux select-window -t :$2" "" "new-window -t :$2
