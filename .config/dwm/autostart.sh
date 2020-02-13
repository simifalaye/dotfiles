#!/bin/bash

# Truncate a couple of common commands that are used herein.
_check() {
    echo "Command: $1" >> /tmp/autostart.txt && command -v $1 >/dev/null
}
_run() {
    if _check $1 && ! pgrep -f $1 >/dev/null; then
        echo "Running $1" >> /tmp/autostart.txt
        $@&
    else
        echo "Already Running $1" >> /tmp/autostart.txt
    fi
}

# Setup env
# ---------

# Configure monitor locations and workspaces
xrandr --output "HDMI-1" --primary --mode 1920x1080 --pos 0x550
xrandr --output "HDMI-2" --mode 1920x1080 --rotate left
# Set mouse pointer and keyboard settings
xsetroot -cursor_name left_ptr
xset r rate 350 40
# Restore background settings
_check nitrogen && nitrogen --restore

# Run Apps
# ---------

# The hotkey daemon that handles all custom key bindings, including the
# ones that control BSPWM.  No real need to check for the presence of
# this executable, because it is a dependency of the BSPWM package.
_run sxhkd -c ~/.config/sxhkd/sxhkdrc
# Display compositor for enabling shadow effects and transparency
# (disable it if performance is bad---also bear in mind that I do not
# use transparent areas in any of my interfaces).
_run compton --config ~/.config/compton/compton.conf
# Launch dunst
_run dunst -config ~/.config/dunst/dunstrc
# Launch status bar
_run ~/bin/dwm_status2d
