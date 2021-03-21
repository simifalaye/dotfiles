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
# Set display layout
layout_file=$HOME/.screenlayout/current.sh
if _check xrandr && _check $layout_file; then
    xrandr -q && $layout_file
fi
# Fix Java apps
_check wmname && wmname LG3D
# Restore background settings
_check nitrogen && nitrogen --restore

# Run Apps
# ---------

# Restore background settings
_run nitrogen --restore
# Run auto  blue light filter
_run redshift -l geoclue2
# Run compositor
# compton --config ~/.config/compton/compton.conf
