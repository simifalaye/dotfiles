#!/usr/bin/env sh
# xinitrc runs automatically when you run startx.
# ================================================

# There are some small but important commands that need to be run when we start
# the graphical environment. I keep those commands in ~/.xprofile because that
# file is run automatically if using a display manager (login screen) and so
# they are needed there. To prevent doubling up commands, I source them here
# with the line below.
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
        [ -x "$f" ] && . "$f"
    done
fi

# user init scripts and settings
[ -r /etc/X11/xinit/.Xmodmap ] && xmodmap /etc/X11/xinit/.Xmodmap
[ -r $HOME/.Xmodmap ] && xmodmap $HOME/.Xmodmap
[ -r $HOME/.Xresources ] && xrdb -merge $HOME/.Xresources
[ -r $HOME/.xprofile ] && . $HOME/.xprofile
