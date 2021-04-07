#!/bin/bash

# Description
# ===========
# Restarts the compton compositor
# Requirements: compton
#
# Args: None
# Outputs: None
# Side-effect: Restarts compton process

if command -v compton > /dev/null; then
    killall -q "compton"
    while pgrep -x "compton" >/dev/null; do sleep 1; done
    compton --config "$HOME/.config/compton/compton.conf" &
    notify-send -i ubuntu-logo-icon "Compton" "Reloaded"
fi
