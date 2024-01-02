#!/bin/bash

#-
#  main
#-

idx_str="${1}"

# Set default values based on the base-index used
idx=0
min=0
max=9
if [ "$(tmux show-option -gv base-index)" != "1" ]; then
  idx=1
  min=1
  max=10
fi

# Check if the variable is an integer
if [[ ${idx_str} =~ ^[0-9]+$ ]]; then
  # Check if the integer is within the range
  if ((idx_str >= min && idx_str <= max)); then
    idx=${idx_str}
  fi
fi

# Select window
if ! tmux select-window -t :"${idx}"; then
  tmux new-window -t :"${idx}"
fi
