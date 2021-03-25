#!/usr/bin/env sh
# Start applications when running WM
# ====================================

# Truncate a couple of common commands that are used herein.
_check() {
    command -v $1 >/dev/null
}
_run() {
    if _check $1 && ! pgrep -f $1 >/dev/null; then
        $@&
    fi
}

# Setup env
# ---------

# IMPORTANT: Enable use of gnome settings and etc
export XDG_CURRENT_DESKTOP=GNOME
# Set display layout (if more than one monitor is detected)
layout_file=$HOME/.screenlayout/current.sh
if _check $layout_file; then
    num_screens=$(xrandr -q | grep -i " connected" | wc -l)
    [ "$num_screens" -gt 1 ] && $layout_file
fi
# Fix Java apps
_check wmname && wmname LG3D
# Restore background settings
_check nitrogen && nitrogen --restore

# Run Apps
# ---------

# Start gnome authentication
_run /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1
# Restore background settings
_run nitrogen --restore
# Run auto  blue light filter
_run redshift -l geoclue2
# Run compositor
# _run compton --config ~/.config/compton/compton.conf
_run xcompmgr -c -n
