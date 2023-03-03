# shellcheck disable=SC2148

#-
#  General
#-

# When leaving the console clear the screen to increase privacy
if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

#-
#  Applications
#-

# Trash
# -----
if is_callable trash; then
    # Remove files that have been trashed more than 30 days ago
    if [ -z "$TMUX" ]; then
        trash-empty 30
    fi
fi
