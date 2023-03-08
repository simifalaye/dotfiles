#!/bin/bash

width=${2:-80%}
height=${2:-80%}
if [ "$(tmux display-message -p -F "#{session_name}")" = "scratch" ];then
    tmux detach-client
else
    tmux popup -d '#{pane_current_path}' -w"$width" -h"$height" -E "tmux attach -t scratch || tmux new -s scratch"
fi
