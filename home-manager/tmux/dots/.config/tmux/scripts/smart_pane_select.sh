#!/bin/bash

in_vim() {
  local pane_tty
  pane_tty=$(tmux display-message -p "#{pane_tty}")
  ps -o state= -o comm= -t "${pane_tty}" | \
    grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'
}

#-
#  main
#-

keys="${1}"
dir="${2}"

# Disable vim integration for now
# if in_vim; then
#   # Send keys as they are
#   tmux send-keys "${keys}"
# elif [ "$(tmux display-message -p '#{window_zoomed_flag}')" = 1 ]; then
if [ "$(tmux display-message -p '#{window_zoomed_flag}')" = 1 ]; then
  # If zoomed, goto next pane and keep zoomed
  if [ "${dir}" == "D" ] || [ "${dir}" == "L" ]; then
    tmux select-pane -t :.+ -Z
  else
    tmux select-pane -t :.- -Z
  fi
else
  # Go to pane in direction
  tmux select-pane -"${dir}"
fi
