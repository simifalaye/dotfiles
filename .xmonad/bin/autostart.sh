#!/usr/bin/env sh
# Start applications when running WM
# ====================================

# Truncate a few of common commands that are used herein.
_check() { command -v $1 >/dev/null; }
_run() { # Run if not running
    if _check $1 && ! pgrep -x $1 >/dev/null; then
        $@ &
    fi
}
_res() { # Restart
    killall -q $1
    while pgrep -x $1 >/dev/null; do sleep 1; done
    _run $@
}

# Main
# ------

# Setup auto locker (lock after 30 minutes)
_run xautolock -time 30 -locker slock -notify 10
# Run auto  blue light filter
_run redshift -l geoclue2
# Run compositor
_run compton --config ~/.config/compton/compton.conf
# Run Dunst
_run dunst -config $HOME/.config/dunst/dunstrc
# Run Trayer
_run trayer --edge top --align right --widthtype request \
    --padding 6 --SetDockType true --SetPartialStrut true \
    --expand true --monitor 1 --transparent true --alpha 0 \
    --tint 0x000000 --height 20 --iconspacing 2
# Restore background settings
_check nitrogen && nitrogen --restore
# Run pulse audio applet
_run pasystray
# Run nm-applet
# _run nm-applet
