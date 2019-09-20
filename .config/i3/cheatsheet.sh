#!/bin/sh

[ -x /usr/local/bin/mdless ] && LESSCMD="mdless" || LESSCMD="less"
[ -x /usr/local/bin/st ] && TERMCMD="st" || TERMCMD="i3-sensible-terminal"

path=${1}
append=""

if [ -f $path ]; then
    if $(echo "$path" | grep "vim" > /dev/null 2>&1); then
        $TERMCMD -T "Cheatsheet" -e sh -c "$LESSCMD $path ~/.config/nvim/mappings.vim"
    else
        $TERMCMD -T "Cheatsheet" -e sh -c "$LESSCMD $path"
    fi
else
    echo "Cheatsheet dne."
fi
