#!/usr/bin/env sh
# Setup env
# ===========

_check() {
    command -v $1 >/dev/null
}

# Main
# ------

# Set display layout (if more than one monitor is detected)
layout_file=$HOME/.screenlayout/current.sh
if _check $layout_file; then
    num_screens=$(xrandr -q | grep -i " connected" | wc -l)
    [ "$num_screens" -gt 1 ] && $layout_file
fi
# Start gnome auth agent
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1
