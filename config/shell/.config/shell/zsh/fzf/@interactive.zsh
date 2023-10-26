# shellcheck shell=zsh

if ! is_callable fzf; then
  return 1
fi

# Source fzf keybinds
include /usr/share/doc/fzf/examples/key-bindings.zsh

#-
#  Define zle overrides
#  - Default fzf keybinds call reset-prompt.
#    Don't need to do that as we always call it as part of the zle-line-init.
#-

function disable-reset-prompt {
  zle -A reset-prompt store-reset-prompt
  reset-prompt(){}
  zle -N reset-prompt
}

function restore-reset-prompt {
  zle -A store-reset-prompt reset-prompt
}

wrap-fzf-file-widget() {
  disable-reset-prompt
  zle fzf-file-widget
  restore-reset-prompt
}
zle -N wrap-fzf-file-widget
bindkey "${keys[Ctrl]}t" wrap-fzf-file-widget

# Unbind cd widget
bindkey -r "${keys[Alt]}c"

wrap-fzf-history-widget() {
  disable-reset-prompt
  zle fzf-history-widget
  restore-reset-prompt
}
zle -N wrap-fzf-history-widget
bindkey "${keys[Ctrl]}r" wrap-fzf-history-widget
