#!/bin/bash

# Description
# ===========
# Restarts dunst
# Requirements: dunst
#
# Args: None
# Outputs: None
# Side-effect: Restarts dunst process

if command -v dunst > /dev/null; then
    killall -q "dunst"
    while pgrep -x "dunst" >/dev/null; do sleep 1; done
    dunst -config "$HOME/.config/dunst/dunstrc" &
    notify-send -i ubuntu-logo-icon "Dunst" "Reloaded"
fi
