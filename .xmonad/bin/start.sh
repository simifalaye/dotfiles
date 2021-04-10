#!/bin/bash

# Description
# ===========
# Restarts an app
# Requirements: compton
#
# Args: the command and arguments
# Outputs: None
# Side-effect: Restarts the process

if command -v $1 > /dev/null; then
    if pgrep -x compton > /dev/null; then
        killall -q $1
        while pgrep -x $1 >/dev/null; do sleep 1; done
    fi
    $@ &
    notify-send -i ubuntu-logo-icon "Started app" "$1"
fi
