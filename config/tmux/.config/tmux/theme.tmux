# vim: filetype=conf

# Status bar
set -g status           on
set -g status-position top
set -g status-interval 3     # update the status bar every 3 seconds
set -g status-left "#[fg=blue,bold] #S   "
set -g status-right "#{prefix_highlight} #[fg=brightwhite,bold]%a %Y-%m-%d 󱑒 %l:%M %p "
set -g status-justify left
set -g status-left-length 200    # increase length (from 10)
set -g status-right-length 200    # increase length (from 10)
set -g status-style 'bg=default' # transparent
set -g window-status-style fg=white,bg=default
set -g window-status-current-format '#[fg=black,bg=blue] #I #W#{?window_zoomed_flag,(),} '
set -g window-status-format '#[fg=gray,bg=#1e1e2e] #I #W '
set -g window-status-last-style 'fg=white,bg=black'

# Message
set -g message-command-style bg=default,fg=yellow
set -g message-style bg=default,fg=yellow

# Pane
set -g pane-active-border-style 'fg=magenta,bg=default'
set -g pane-border-style 'fg=brightblack,bg=default'
