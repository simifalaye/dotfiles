# vim: filetype=conf
#
# Configuration of tmux key bindings.
#

# Load additional keybinds configured through shell functions
run-shell "${TMUX_CONFIG_DIR}/bindings.sh"

#-
#  Root
#-

is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'";

# Pane selection with awareness of Vim splits.
# See: https://github.com/mrjones2014/smart-splits.nvim
bind -N "Select pane left" -n M-h if-shell "$is_vim" 'send-keys M-h'  'select-pane -L'
bind -N "Select pane down" -n M-j if-shell "$is_vim" 'send-keys M-j'  'select-pane -D'
bind -N "Select pane up" -n M-k if-shell "$is_vim" 'send-keys M-k'  'select-pane -U'
bind -N "Select pane right" -n M-l if-shell "$is_vim" 'send-keys M-l'  'select-pane -R'

# Pane resize with awareness of Vim splits.
# See: https://github.com/mrjones2014/smart-splits.nvim
bind -N "Resize left" -n M-H if-shell "$is_vim" 'send-keys M-H' 'resize-pane -L 3'
bind -N "Resize down" -n M-J if-shell "$is_vim" 'send-keys M-J' 'resize-pane -D 3'
bind -N "Resize up" -n M-K if-shell "$is_vim" 'send-keys M-K' 'resize-pane -U 3'
bind -N "Resize right" -n M-L if-shell "$is_vim" 'send-keys M-L' 'resize-pane -R 3'
bind -N 'Zoom the current pane' -n M-z resize-pane -Z

# Pane movement
bind -N "Move pane left" -n "M-C-h" swap-pane -s '{left-of}'
bind -N "Move pane down" -n "M-C-j" swap-pane -s '{down-of}'
bind -N "Move pane up" -n "M-C-k" swap-pane -s '{up-of}'
bind -N "Move pane right" -n "M-C-l" swap-pane -s '{right-of}'

# Layout selection
bind -N 'Layout next' -n 'M-]' next-layout
bind -N 'Layout prev' -n 'M-[' previous-layout

# Quick new pane
bind -N 'New pane' -n "M-Enter" \
		run-shell 'cwd="`tmux display -p \"#{pane_current_path}\"`"; tmux select-pane -t "bottom-right"; tmux split-pane -c "$cwd"';

# Name a window with Alt + n.
bind -N 'Name window' -n "M-n" \
	command-prompt -p 'Window name:' 'rename-window "%%"';

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

# Config
bind -N 'Edit the tmux configuration'   'e' edit-config
bind -N 'Reload the tmux configuration' 'r' reload

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
bind -N 'Select the last window' 'l' last-window
bind -N 'Select the next window' -r 'M-]' next-window
bind -N 'Select the previous window' -r 'M-[' previous-window
bind -N 'Swap window right' -r 'M-{' swap-window -d -t -1
bind -N 'Swap window left' -r 'M-}' swap-window -d -t +1

# Window layouts.
bind -N 'Select the even-horizontal layout' 'M-1' select-layout even-horizontal
bind -N 'Select the even-vertical layout' 'M-2' select-layout even-vertical
bind -N 'Select the main-horizontal layout' 'M-3' select-layout main-horizontal
bind -N 'Select the main-vertical layout' 'M-4' select-layout main-vertical
bind -N 'Select the tiled layout' 'M-5' select-layout tiled
bind -N 'Spread the panes out evenly' '=' select-layout -E

# Pane operations
bind -N 'Mark the current pane' 'm' select-pane -m
bind -N 'Clear the marked pane' 'M' select-pane -M
bind -N 'Join the marked pane with the current pane' 'M-y' join-pane
bind -N 'Kill the current pane' 'x' kill-pane

# Enter backward search mode directly.
bind -N 'Search backward for a regular expression' '/' copy-mode \; send '?'

# Keymap information.
bind -N 'List key bindings' '?' display-popup -w80 -h90% -E "tmux list-keys -N | $PAGER"
bind -N 'Describe a key binding' '.' command-prompt -k -p "(key)" { list-keys -1N "%%" }

# Customize mode.
bind -N 'Customize options and bindings' ',' customize-mode -Z

# Status line commands.
bind -N 'Prompt for a command'      ':' command-prompt
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
