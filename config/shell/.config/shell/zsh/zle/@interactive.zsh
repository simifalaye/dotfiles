# shellcheck shell=zsh

#
# ZLE(Zsh Line Editor) configuration module
#
# NOTE: This module should be loaded after the completion module.
# This is necessary so that the `menuselect` keymap and the bindable commands
# of the completion system are available. For more information about the
# latter, see the definition of _rebind_compsys_widgets below.
# NOTE: Dependent on the zim input module
#

if [[ $TERM == 'dumb' ]]; then
  return 1
fi

#-
#  ZLE Widgets
#-

# Explicitly load terminfo
zmodload zsh/terminfo

# Toggle process as bg and fg
function fancy-ctrl-z {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z

# List key bindings.
function list-keys {
  bindkey | grep -v noop | "$PAGER"
}
zle -N list-keys

#-
#  Keymaps
#-

# Toggle process bg and fg
bindkey "$key_info[Control]z" fancy-ctrl-z

# List key bindings.
bindkey "$key_info[Control]x$key_info[Control]?" list-keys

# plugin: zsh-history-substring-search
bindkey "$key_info[Up]" history-substring-search-up
bindkey "$key_info[Control]p" history-substring-search-up
bindkey "$key_info[Down]" history-substring-search-down
bindkey "$key_info[Control]n" history-substring-search-down

# plugin: zsh-autosuggestions
bindkey "$key_info[Control] " autosuggest-accept
