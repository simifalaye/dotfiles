# shellcheck shell=bash

if ! is_callable fzf; then
  return 1
fi

# Source fzf keybinds
include /usr/share/doc/fzf/examples/key-bindings.bash
