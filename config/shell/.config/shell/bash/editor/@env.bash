# shellcheck shell=bash

# Define the default editor.
if is_callable nvim; then
  export EDITOR='nvim'
elif is_callable vi; then
  export EDITOR='vi'
elif is_callable nano; then
  export EDITOR='nano'
fi
export GIT_EDITOR="$EDITOR"
export USE_EDITOR="$EDITOR"
export VISUAL="$EDITOR"
