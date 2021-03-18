#!/bin/bash
# vim: ft=sh

# Volume controls
# ================
# Requirements:
# - Following scripts must be executable in $PATH:
#     # get_progress_string
#     # volume_amixer

# Functions
# ----------
# Get the name of the selected sink:
get_sink_name() {
    pacmd stat | awk -F": " '/^Default sink name: /{print $2}'
}
# Get the selected sink volume
get_sink_vol() {
    pacmd list-sinks |
        awk '/^\s+name: /{indefault = $2 == "<'$(get_sink_name)'>"}
            /^\s+volume: / && indefault {print $5; exit}'
}
# Get the selected sink mute status
get_sink_muted() {
    muted=$(pacmd list-sinks |
            awk '/^\s+name: /{indefault = $2 == "<'$(get_sink_name)'>"}
            /^\s+muted: / && indefault {print $2; exit}')
    if [ $muted == "yes" ]; then
        echo "0"
        return 0
    fi
    echo "1"
    return 1
}
# Set volume of sink
mute_toggle() {
    pactl set-sink-mute $NAME toggle
}
inc_vol() {
    vol=$(($1 + $INCR))
    [ $vol -gt 100 ] && vol=100

    [ $MUTED -eq 0 ] && mute_toggle
    pactl set-sink-volume $NAME $vol%
}
dec_vol() {
    vol=$(($1 - $INCR))
    [ $vol -lt 0 ] && vol=0

    [ $MUTED -eq 0 ] && mute_toggle
    pactl set-sink-volume $NAME $vol%
}

# Main
# ======

# Globals
NAME=$(get_sink_name)
MUTED=$(get_sink_muted)
INCR=5

# Change the volume or toggle mute
volume_level="$(get_sink_vol | sed 's/[^0-9]*//g')"
case $1 in
    inc)
        inc_vol $volume_level
        ;;
    dec)
        dec_vol $volume_level
        ;;
    mute)
        mute_toggle
        ;;
    vol_str)
        if [ $MUTED -eq 0 ]; then
            echo "婢 off"
        elif [ $volume_level -lt 30 ]; then
            echo "奄 $volume_level%"
        elif [ $volume_level -ge 30 ] && [ $volume_level -le 60 ]; then
            echo "奔 $volume_level%"
        elif [ $volume_level -gt 60 ]; then
            echo "墳 $volume_level%"
        fi
        exit 0
        ;;
    vol)
        echo "$volume_level" && exit 0
        ;;
    *)
        echo "Error: Not a valid volume command" && exit 1
esac

# Play sound
canberra-gtk-play -i audio-volume-change -d "changeVolume"
