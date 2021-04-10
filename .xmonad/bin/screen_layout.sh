#!/bin/bash
# Setup screenlayout
# ====================

# Set display layout (if more than one monitor is detected)
layout_file=~/.screenlayout/current.sh
if [[ -x "$layout_file" ]]; then
    num_screens=$(xrandr -q | grep -i " connected" | wc -l)
    [ "$num_screens" -gt 1 ] && $layout_file
fi
