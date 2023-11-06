#!/bin/sh

#-
#  Helper functions
#-

# Define core functionality {{{
bind_switch () {
	# Bind keys to switch between workspaces.
	tmux bind -N "Select window ${2}" -n "${1}" \
		if-shell "tmux select-window -t :${2}" "" "new-window -t :${2}"
}

bind_move () {
	# Bind keys to move panes between workspaces.
	tmux bind -N "Move window to ${2}" -n "$1" \
			if-shell "tmux join-pane -t :$2" \
				"" \
				"new-window -dt :$2; join-pane -t :$2; select-pane -t top-left; kill-pane" \\\;\
			select-layout \\\;\
			select-layout -E
}

#-
#  Main
#-

# Switch to workspace
bind_switch "M-1" 1
bind_switch "M-2" 2
bind_switch "M-3" 3
bind_switch "M-4" 4
bind_switch "M-5" 5
bind_switch "M-6" 6
bind_switch "M-7" 7
bind_switch "M-8" 8
bind_switch "M-9" 9

# Move pane to workspace
bind_move "M-!" 1
bind_move "M-@" 2
bind_move "M-#" 3
bind_move "M-$" 4
bind_move "M-%" 5
bind_move "M-^" 6
bind_move "M-&" 7
bind_move "M-*" 8
bind_move "M-(" 9

# Depends on base index. It can either refer to workspace number 0 or workspace number 10.
if [ "$(tmux show-option -gv base-index)" = "1" ]; then
	bind_switch "M-0" 10
	bind_move "M-)" 9
else
	bind_switch "M-0" 0
	bind_move "M-)" 0
fi
