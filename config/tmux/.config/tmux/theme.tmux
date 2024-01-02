# vim: filetype=conf

keys_locked="#[fg=white,bg=black]#([ $(tmux show-option -qv key-table) = 'off' ] && echo 'OFF')#[default]"

# Status bar
set -g status on
set -g status-position top
set -g status-left "#[bg=default,fg=white]#{?client_prefix,, #S }#[bg=blue,fg=black]#{?client_prefix, #S ,}"
set -g status-right "$keys_locked #[fg=brightwhite,bold]%a %Y-%m-%d %l:%M %p "
set -g status-justify left
set -g status-left-length 200    # increase length (from 10)
set -g status-right-length 200    # increase length (from 10)
set -g status-bg default
set -g status-style bg=default # transparent
set -g window-status-format '#[fg=gray,bg=default] #I:#W '
set -g window-status-current-format '#[fg=black,bg=blue] #I:#W#{?window_zoomed_flag,(),} '

# Message
set -g message-command-style bg=default,fg=yellow
set -g message-style bg=default,fg=yellow

# Pane
set -g pane-active-border-style 'fg=magenta,bg=default'
set -g pane-border-style 'fg=brightblack,bg=default'
