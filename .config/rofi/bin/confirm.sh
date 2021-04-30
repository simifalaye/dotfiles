#!/usr/bin/env sh

yes='Confirm'
no='Cancel'
query='Are you sure?'

while [ $# -ne 0 ]; do
    case "$1" in
        -y | --yes)
            [ -n "$2" ] && yes="$2" || yes=''
            shift
            ;;

        -n | --no)
            [ -n "$2" ] && no="$2" || no=''
            shift
            ;;

        -q | --query)
            [ -n "$2" ] && query="$2"
            shift
            ;;
    esac
    shift
done

chosen=$(printf '%s;%s\n' "$yes" "$no" \
    | rofi -p "$query" \
           -dmenu -i \
           -sep ';' \
           -selected-row 1)

case "$chosen" in
    "$yes") exit 0 ;;
    "$no")  exit 1 ;;
esac
