#!/bin/bash

in_vim() {
  local pane_tty=$(tmux display-message -p "#{pane_tty}")
  ps -o state= -o comm= -t "${pane_tty}" | \
    grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'
}

#-
#  main
#-

keys="${1}"
dir="${2}"
amount="${3}"

if in_vim; then
  # Send keys as they are
  tmux send-keys "${keys}"
else
  # Go to pane in direction
  tmux resize-pane -"${dir}" "${amount}"
fi
