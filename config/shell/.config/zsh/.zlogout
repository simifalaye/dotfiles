# vim: filetype=zsh

#-
#  General
#-

# When leaving the console clear the screen to increase privacy
if [ -n "${SHLVL}" ] && [ "${SHLVL}" = 1 ]; then
  [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

#-
#  App: Trash-cli
#-

if is_callabe trash; then
  # Remove files that have been trashed more than 30 days ago
  if [ -z "$TMUX" ] && [-z "$ZELLIJ"]; then
    trash-empty 30
  fi
fi
