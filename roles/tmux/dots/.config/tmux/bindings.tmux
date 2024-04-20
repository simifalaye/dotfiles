# vim: filetype=conf
#
# Configuration of tmux key bindings.
#

TMUX_SCRIPT_DIR="${TMUX_CONFIG_DIR}/scripts"

if-shell -b '[ "$(echo "$TMUX_VERSION >= 3.1" | bc)" = 1 ]' { # Require for '-N' flag

#-
#  Root
#-

# Bind lock/unlock keys for nested sessions
bind -T root -N 'Lock keys' 'M-g'  \
  set prefix None \;\
  set key-table off \;\
  if -F '#{pane_in_mode}' 'send-keys -X cancel' \;\
  refresh-client -S
bind -T off -N 'Unlock keys' 'M-g' \
  set -u prefix \;\
  set -u key-table \;\
  refresh-client -S

# Bind window selection
bind -n -N 'Select window 1' 'M-1' run '${TMUX_SCRIPT_DIR}/smart_window_select.sh 1'
bind -n -N 'Select window 2' 'M-2' run '${TMUX_SCRIPT_DIR}/smart_window_select.sh 2'
bind -n -N 'Select window 3' 'M-3' run '${TMUX_SCRIPT_DIR}/smart_window_select.sh 3'
bind -n -N 'Select window 4' 'M-4' run '${TMUX_SCRIPT_DIR}/smart_window_select.sh 4'
bind -n -N 'Select window 5' 'M-5' run '${TMUX_SCRIPT_DIR}/smart_window_select.sh 5'
bind -n -N 'Select window 6' 'M-6' run '${TMUX_SCRIPT_DIR}/smart_window_select.sh 6'
bind -n -N 'Select window 7' 'M-7' run '${TMUX_SCRIPT_DIR}/smart_window_select.sh 7'
bind -n -N 'Select window 8' 'M-8' run '${TMUX_SCRIPT_DIR}/smart_window_select.sh 8'
bind -n -N 'Select window 9' 'M-9' run '${TMUX_SCRIPT_DIR}/smart_window_select.sh 9'
bind -n -N 'Select window 10' 'M-0' run '${TMUX_SCRIPT_DIR}/smart_window_select.sh 10'
bind -n -N 'Select the next window' 'M-]' next-window
bind -n -N 'Select the previous window' 'M-[' previous-window

# Bind window movement
bind -n -N 'Swap window right' 'M-{' swap-window -d -t -1
bind -n -N 'Swap window left' 'M-}' swap-window -d -t +1

# Bind pane selection
bind -n -N 'Select pane left' 'M-h' run '${TMUX_SCRIPT_DIR}/smart_pane_select.sh M-h L'
bind -n -N 'Select pane down' 'M-j' run '${TMUX_SCRIPT_DIR}/smart_pane_select.sh M-j D'
bind -n -N 'Select pane up' 'M-k' run '${TMUX_SCRIPT_DIR}/smart_pane_select.sh M-k U'
bind -n -N 'Select pane right' 'M-l' run '${TMUX_SCRIPT_DIR}/smart_pane_select.sh M-l R'

# Bind pane movement
bind -n -N 'Move pane 1' 'M-!' run '${TMUX_SCRIPT_DIR}/smart_pane_move.sh 1'
bind -n -N 'Move pane 2' 'M-@' run '${TMUX_SCRIPT_DIR}/smart_pane_move.sh 2'
bind -n -N 'Move pane 3' 'M-#' run '${TMUX_SCRIPT_DIR}/smart_pane_move.sh 3'
bind -n -N 'Move pane 4' 'M-$' run '${TMUX_SCRIPT_DIR}/smart_pane_move.sh 4'
bind -n -N 'Move pane 5' 'M-%' run '${TMUX_SCRIPT_DIR}/smart_pane_move.sh 5'
bind -n -N 'Move pane 6' 'M-^' run '${TMUX_SCRIPT_DIR}/smart_pane_move.sh 6'
bind -n -N 'Move pane 7' 'M-&' run '${TMUX_SCRIPT_DIR}/smart_pane_move.sh 7'
bind -n -N 'Move pane 8' 'M-*' run '${TMUX_SCRIPT_DIR}/smart_pane_move.sh 8'
bind -n -N 'Move pane 9' 'M-(' run '${TMUX_SCRIPT_DIR}/smart_pane_move.sh 9'
bind -n -N 'Move pane 10' 'M-)' run '${TMUX_SCRIPT_DIR}/smart_pane_move.sh 10'
bind -n -N 'Move pane left' 'M-H' swap-pane -s '{left-of}'
bind -n -N 'Move pane down' 'M-J' swap-pane -s '{down-of}'
bind -n -N 'Move pane up' 'M-K' swap-pane -s '{up-of}'
bind -n -N 'Move pane right' 'M-L' swap-pane -s '{right-of}'

# Bind pane resizing
bind -n -N 'Resize left' 'M-C-h' run '${TMUX_SCRIPT_DIR}/smart_pane_resize.sh M-C-h L 3'
bind -n -N 'Resize down' 'M-C-j' run '${TMUX_SCRIPT_DIR}/smart_pane_resize.sh M-C-j D 3'
bind -n -N 'Resize up' 'M-C-k' run '${TMUX_SCRIPT_DIR}/smart_pane_resize.sh M-C-k U 3'
bind -n -N 'Resize right' 'M-C-l' run '${TMUX_SCRIPT_DIR}/smart_pane_resize.sh M-C-l R 3'
bind -n -N 'Zoom the current pane' 'M-z' resize-pane -Z

# See: https://www.reddit.com/r/tmux/comments/j7fcr7/tiling_in_tmux_as_in_bspwm/
bind -n -N 'New pane' 'M-/' if-shell \
       "[ $(($(tmux display -p '8*#{pane_width}-20*#{pane_height}'))) -lt 0 ]" "splitw -v -c '#{pane_current_path}'" "splitw -h -c '#{pane_current_path}' "

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
#  Pane mode
#-

bind -n -N '-- Mode: Pane (help = M-p + ?)' 'M-p' switch-client -T pane_mode

bind -T pane_mode -N 'Split below' 's' split-window -v -c "#{pane_current_path}"
bind -T pane_mode -N 'Slit right' 'v' split-window -h -c "#{pane_current_path}"
bind -T pane_mode -N 'Select left' 'h' select-pane -L
bind -T pane_mode -N 'Select down' 'j' select-pane -D
bind -T pane_mode -N 'Select up' 'k' select-pane -U
bind -T pane_mode -N 'Select Right' 'l' select-pane -R
bind -T pane_mode -N 'Select last' 'p' last-pane
bind -T pane_mode -N 'Mark' 'm' select-pane -m
bind -T pane_mode -N 'Clear mark' 'M' select-pane -M
bind -T pane_mode -N 'Break to new window' 'b' break-pane
bind -T pane_mode -N 'Join marked with current' 'y' join-pane
bind -T pane_mode -N 'Kill' 'x' kill-pane
bind -T pane_mode -N 'List key bindings' '?' display-popup -w80 -h90% -E "tmux list-keys -N -T pane_mode | $PAGER"

#-
#  Window mode
#-

bind -n -N '-- Mode: Window (help = M-w + ?)' 'M-w' switch-client -T window_mode

bind -T window_mode -N 'New' 'n' new-window -c "#{pane_current_path}"
bind -T window_mode -N 'Rename' 'r' command-prompt -I "#W" { rename-window "%%" }
bind -T window_mode -N 'Kill' 'x' confirm-before -p "kill-window #W? (y/n)" kill-window
bind -T window_mode -N 'Select last' 'w' last-window
bind -T window_mode -N 'Select interactively' 'Space' choose-tree -Zw
bind -T window_mode -N 'Layout: even side-by-side' '\' select-layout even-horizontal
bind -T window_mode -N 'Layout: main side-by-side' '|' select-layout main-vertical
bind -T window_mode -N 'Layout: even top-down' '-' select-layout even-vertical
bind -T window_mode -N 'Layout: main top-down' '_' select-layout main-horizontal
bind -T window_mode -N 'Layout: tiled' '+' select-layout tiled
bind -T window_mode -N 'Layout: even spread' '=' select-layout -E
bind -T window_mode -N 'Toggle activity monitoring' 'm' {
  set monitor-activity
    display 'monitor-activity #{?monitor-activity,on,off}'
}
bind -T window_mode -N 'Toggle silence monitoring' 'M' {
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

bind -T window_mode -N 'Toggle pane synchronization' 's' {
  set synchronize-panes
    display 'synchronize-panes #{?synchronize-panes,on,off}'
}
bind -T window_mode -N 'List key bindings' '?' display-popup -w80 -h90% -E "tmux list-keys -N -T window_mode | $PAGER"

#-
#  Session mode
#-

bind -n -N '-- Mode: Session (help = M-s + ?)' 'M-s' switch-client -T session_mode

bind -T session_mode -N 'Detach' 'd' detach-client
bind -T session_mode -N 'Kill' 'x' confirm-before -p "kill-session #S? (y/n)" kill-session
bind -T session_mode -N 'Select last' 's' switch-client -l
bind -T session_mode -N 'Select last' 'M-s' switch-client -l
bind -T session_mode -N 'Select next' -r 'l' switch-client -n
bind -T session_mode -N 'Select prev' -r 'h' switch-client -p
bind -T session_mode -N 'Select interactively' 'Space' choose-tree -Zs
bind -T session_mode -N 'Create a new session' 'n' command-prompt { new-session -s "%%" }
bind -T session_mode -N 'Rename the current session' 'r' command-prompt -I "#S" { rename-session "%%" }
bind -T session_mode -N 'List key bindings' '?' display-popup -w80 -h90% -E "tmux list-keys -N -T session_mode | $PAGER"

#-
#  Prefix mode
#-

# Remove all default key bindings.
unbind -a -T prefix

# Set the prefix key
set -g prefix 'M-;'
bind 'M-;' send-prefix
bind -n 'M-a' send-prefix # Nested session prefix

# Config
bind -N 'Edit tmux configuration' 'e' run-shell \
       'tmux popup -w90% -h90% -E -d "#{pane_current_path}" "${VISUAL:-${EDITOR}} $TMUX_CONFIG && tmux reload"'
bind -N 'Reload the tmux configuration' 'r' run-shell \
       'tmux source "$TMUX_CONFIG" && tmux display "sourced $TMUX_CONFIG"'

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

# Enter copy mode.
bind -N 'Enter copy mode' 'Enter' copy-mode

#-
#  Copy mode
#-

# Pane selection with awareness of Vim splits.
# See: https://github.com/mrjones2014/smart-splits.nvim
bind-key -T copy-mode-vi 'M-h' select-pane -L
bind-key -T copy-mode-vi 'M-j' select-pane -D
bind-key -T copy-mode-vi 'M-k' select-pane -U
bind-key -T copy-mode-vi 'M-l' select-pane -R

} # Version >= 3.1
