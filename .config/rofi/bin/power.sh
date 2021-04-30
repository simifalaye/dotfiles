#!/usr/bin/env sh

power_off=' Power off'
reboot=' Reboot'
lock=' Lock'
suspend='鈴 Suspend'
log_out=' Logout'

choice=$(printf '%s|%s|%s|%s|%s\n' \
    "$power_off" "$reboot" "$lock" "$suspend" \ "$log_out" \
    | rofi -dmenu -i \
           -matching "fuzzy" \
           -sep '|' \
           -selected-row 2)

case "$choice" in
    "$power_off")
        ~/.config/rofi/bin/confirm.sh --query 'Shutdown?' &&
            systemctl poweroff
        ;;

    "$reboot")
        ~/.config/rofi/bin/confirm.sh --query 'Reboot?' &&
            systemctl reboot
        ;;

    "$lock")
        slock
        ;;

    "$suspend")
        systemctl suspend
        ;;

    "$log_out")
        pkill -e xmonad
        ;;

    *) exit 1 ;;
esac
