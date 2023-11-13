# vim: filetype=conf
#
# Configuration of tmux key bindings.
#

# Load additional keybinds configured through shell functions
run-shell "${TMUX_CONFIG_DIR}/scripts/switch_move_binds.sh"

#-
#  Root
#-

is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'";


# Window operations
bind -N 'Name window' -n "M-n" \
	     command-prompt -p 'Window name:' 'rename-window "%%"';

# Window selection/movement
bind -N 'Select the next window' -n 'M-]' next-window
bind -N 'Select the previous window' -n 'M-[' previous-window
bind -N 'Swap window right' -n 'M-{' swap-window -d -t -1
bind -N 'Swap window left' -n 'M-}' swap-window -d -t +1

# Pane selection with awareness of Vim splits/movement
# See: https://github.com/mrjones2014/smart-splits.nvim
bind -N "Select pane left" -n M-h if-shell "$is_vim" 'send-keys M-h'  'select-pane -L'
bind -N "Select pane down" -n M-j if-shell "$is_vim" 'send-keys M-j'  'select-pane -D'
bind -N "Select pane up" -n M-k if-shell "$is_vim" 'send-keys M-k'  'select-pane -U'
bind -N "Select pane right" -n M-l if-shell "$is_vim" 'send-keys M-l'  'select-pane -R'
bind -N "Move pane left" -n "M-C-h" swap-pane -s '{left-of}'
bind -N "Move pane down" -n "M-C-j" swap-pane -s '{down-of}'
bind -N "Move pane up" -n "M-C-k" swap-pane -s '{up-of}'
bind -N "Move pane right" -n "M-C-l" swap-pane -s '{right-of}'

# Pane resize with awareness of Vim splits.
# See: https://github.com/mrjones2014/smart-splits.nvim
bind -N "Resize left" -n M-H if-shell "$is_vim" 'send-keys M-H' 'resize-pane -L 3'
bind -N "Resize down" -n M-J if-shell "$is_vim" 'send-keys M-J' 'resize-pane -D 3'
bind -N "Resize up" -n M-K if-shell "$is_vim" 'send-keys M-K' 'resize-pane -U 3'
bind -N "Resize right" -n M-L if-shell "$is_vim" 'send-keys M-L' 'resize-pane -R 3'
bind -N 'Zoom the current pane' -n M-z resize-pane -Z

# Quick new pane
bind -N 'New pane' -n "M-Enter" \
		run-shell 'cwd="`tmux display -p \"#{pane_current_path}\"`"; tmux select-pane -t "bottom-right"; tmux split-pane -c "$cwd"';

# Toggle scratchpad
bind-key -N 'Toggle scratch window' -n M-w if-shell -F '#{==:#{session_name},scratch}' {
  detach-client
} {
  display-popup -d "#{pane_current_path}" -xC -yC -w 80% -h 75% -E 'tmux new-session -A -s scratch'
}

#-
#  Mouse
#-

# Enable mouse support by default.
set -g mouse on

# Prevent status line scrolling from switching windows.
unbind -T root 'WheelUpStatus'
unbind -T root 'WheelDownStatus'

# Fix mouse wheel for applications using legacy scroll.
# See https://github.com/tmux/tmux/issues/1320#issuecomment-381952082.
bind -T root 'WheelUpPane' {
  if -Ft= "#{||:#{pane_in_mode},#{mouse_any_flag}}" {
    send -Mt=
  } {
    if -Ft= '#{alternate_on}' {
      send -t= -N 3 Up
    } {
      copy-mode -et=
    }
  }
}
bind -T root 'WheelDownPane' {
  if -Ft= "#{||:#{pane_in_mode},#{mouse_any_flag}}" {
    send -Mt=
  } {
    if -Ft= '#{alternate_on}' {
      send -t= -N 3 Down
    } {
      send -Mt=
    }
  }
}

# Paste the most recent buffer on middle click.
bind -T root 'MouseDown2Pane' {
  select-pane -t=
  if -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" {
    send -M
  } {
    paste-buffer -p
  }
}

# Copy word with double click
bind -T root 'DoubleClick1Pane' {
  select-pane -t=
  if -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" {
    send -M
  } {
    copy-mode -H; send -X select-word; run -d0.3; send -X copy-pipe-and-cancel
  }
}

# Copy line with triple click
bind -T root 'TripleClick1Pane' {
  select-pane -t=
  if -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" {
    send -M
  } {
    copy-mode -H; send -X select-line; run -d0.3; send -X copy-pipe-and-cancel
  }
}

# Zoom/unzoom the selected pane.
bind -T root 'C-DoubleClick1Pane' resize-pane -Zt=

#-
#  Prefix
#-

# Remove all default key bindings.
unbind -a -T prefix

# Set the prefix key
unbind 'C-b'
set -g prefix 'M-s'
bind 'M-s' send-prefix
bind -n 'M-a' send-prefix # Nested session prefix

# Config
bind -N 'Edit the tmux configuration'   'e' edit-config
bind -N 'Reload the tmux configuration' 'r' reload

# Client operations.
bind -N 'Detach the current client' 'd' detach-client
bind -N 'Suspend the current client' 'z' suspend-client

# Client selection.
bind -N 'Select a client interactively' 'c' choose-client -Z

# Session operations
bind -N 'Create a new session' 'N' command-prompt { new-session -s "%%" }
bind -N 'Rename the current session' 'S' command-prompt -I "#S" { rename-session "%%" }

# Session selection
bind -N 'Select a session interactively' 's' choose-tree -Zs
bind -N 'Select the next session' -r 'Tab' switch-client -n
bind -N 'Select the previous session' -r 'BTab' switch-client -p

# Window operations
bind -N 'Create a new window' 'n' new-window -c "#{pane_current_path}"
bind -N 'Rename the current window' 'W' command-prompt -I "#W" { rename-window "%%" }
bind -N 'Kill the current window' 'X' confirm-before -p "kill-window #W? (y/n)" kill-window
bind -N 'Split the current window horizontally' '|' split-window -h -c "#{pane_current_path}"
bind -N 'Split the current window vertically' '_' split-window -v -c "#{pane_current_path}"

# Window selection/movement
bind -N 'Select a window interactively' 'w' choose-tree -Zw
bind -N 'Select the last window' '`' last-window
bind -N 'Select the next window' 'M-]' next-window
bind -N 'Select the previous window' 'M-[' previous-window
bind -N 'Swap window right' 'M-{' swap-window -d -t -1
bind -N 'Swap window left' 'M-}' swap-window -d -t +1
bind -N 'Select window 1' '1' select-window -t :=1
bind -N 'Select window 2' '2' select-window -t :=2
bind -N 'Select window 3' '3' select-window -t :=3
bind -N 'Select window 4' '4' select-window -t :=4
bind -N 'Select window 5' '5' select-window -t :=5
bind -N 'Select window 6' '6' select-window -t :=6
bind -N 'Select window 7' '7' select-window -t :=7
bind -N 'Select window 8' '8' select-window -t :=8
bind -N 'Select window 9' '9' select-window -t :=9
bind -N 'Select window 10' '0' select-window -t :=10

# Window layouts.
bind -N 'Select the even-horizontal layout' 'M-1' select-layout even-horizontal
bind -N 'Select the even-vertical layout' 'M-2' select-layout even-vertical
bind -N 'Select the main-horizontal layout' 'M-3' select-layout main-horizontal
bind -N 'Select the main-vertical layout' 'M-4' select-layout main-vertical
bind -N 'Select the tiled layout' 'M-5' select-layout tiled
bind -N 'Spread the panes out evenly' '=' select-layout -E
bind -N 'Layout next' -r 'Space' next-layout

# Pane operations
bind -N 'Mark the current pane' 'm' select-pane -m
bind -N 'Clear the marked pane' 'M' select-pane -M
bind -N 'Break the current pane into a new window' 'M-b' break-pane
bind -N 'Join the marked pane with the current pane' 'M-y' join-pane
bind -N 'Kill the current pane' 'x' kill-pane

# Pane selection/movement
bind -N 'List and select a pane by index' 'p' display-panes
bind -N 'Select the last pane' -r '~' last-pane
bind -N 'Select the pane above the active pane' 'k' select-pane -U
bind -N 'Select the pane below the active pane' 'j' select-pane -D
bind -N 'Select the pane to the left of the active pane' 'h' select-pane -L
bind -N 'Select the pane to the right of the active pane' 'l' select-pane -R
bind -N 'Swap the current pane with the pane above' -r 'o' swap-pane -U
bind -N 'Swap the current pane with the pane below' -r 'O' swap-pane -D
bind -N 'Rotate the panes upward in the current window' -r 'C-o' rotate-window -U
bind -N 'Rotate the panes downward in the current window' -r 'M-o' rotate-window -D

# Pane resizing.
bind -N 'Zoom the current pane' 'Space' resize-pane -Z
bind -N 'Resize the current pane up' -r 'M-Up' resize-pane -U
bind -N 'Resize the current pane down' -r 'M-Down' resize-pane -D
bind -N 'Resize the current pane left' -r 'M-Left' resize-pane -L
bind -N 'Resize the current pane right' -r 'M-Right' resize-pane -R

# Enter backward search mode directly.
bind -N 'Search backward for a regular expression' '/' copy-mode \; send '?'

# Keymap information.
bind -N 'List key bindings' '?' display-popup -w80 -h90% -E "tmux list-keys -N | $PAGER"
bind -N 'Describe a key binding' '.' command-prompt -k -p "(key)" { list-keys -1N "%%" }

# Customize mode.
bind -N 'Customize options and bindings' ',' customize-mode -Z

# Status line commands.
bind -N 'Prompt for a command' ':' command-prompt
bind -N 'Show status line messages' ';' show-messages

# Activity monitoring.
bind -N 'Toggle activity monitoring for the current window' '@' {
  set monitor-activity
  display 'monitor-activity #{?monitor-activity,on,off}'
}

# Silence monitoring.
bind -N 'Toggle silence monitoring for the current window' '!' {
  if -F '#{monitor-silence}' {
    set monitor-silence 0
    display 'monitor-silence off'
  } {
    command-prompt -p "(silence interval)" -I "2" {
      set monitor-silence '%%'
      display 'monitor-silence #{monitor-silence}'
    }
  }
}

# Pane synchronization.
bind -N 'Toggle pane synchronization in the current window' '#' {
  set synchronize-panes
  display 'synchronize-panes #{?synchronize-panes,on,off}'
}

# Enter copy mode.
bind -N 'Enter copy mode' 'Enter' copy-mode

#-
#  Copy mode
#-

# Pane selection with awareness of Vim splits.
# See: https://github.com/mrjones2014/smart-splits.nvim
bind-key -T copy-mode-vi 'C-h' select-pane -L
bind-key -T copy-mode-vi 'C-j' select-pane -D
bind-key -T copy-mode-vi 'C-k' select-pane -U
bind-key -T copy-mode-vi 'C-l' select-pane -R
