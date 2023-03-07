# shellcheck shell=sh

# When leaving the console clear the screen to increase privacy
if [ -n "${SHLVL}" ] && [ "${SHLVL}" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi
