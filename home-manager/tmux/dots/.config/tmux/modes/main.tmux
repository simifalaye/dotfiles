# Set status mode
set -g @tmux_status_mode ""
set -g @tmux_status_mode_bg ""

# Unbind unneccesary tables
unbind -n -a

# Reset input state
run-shell "${TMUX_SCRIPTS_DIR}/input_reset.sh"
set-hook -gu client-attached "select-pane -d"
set-hook -gu client-focus-in "select-pane -d"
set-hook -gu window-pane-changed "select-pane -d"
set-hook -gu session-window-changed "select-pane -d"

# Modes
bind -n -N 'Mode: Locked' 'M-g' source "${TMUX_MODES_DIR}/locked.tmux"
bind -n -N 'Mode: Pane' 'M-p' source "${TMUX_MODES_DIR}/pane.tmux"
bind -n -N 'Mode: Resize' 'M-r' source "${TMUX_MODES_DIR}/resize.tmux"
bind -n -N 'Mode: Session' 'M-s' source "${TMUX_MODES_DIR}/session.tmux"
bind -n -N 'Mode: Window' 'M-w' source "${TMUX_MODES_DIR}/window.tmux"

bind-key -n MouseDown1Pane select-pane -t = \; send-keys -M
bind-key -n MouseDown1Status select-window -t =
bind-key -n MouseDrag1Pane if-shell -F -t = "#{mouse_any_flag}" "if -Ft= \"#{pane_in_mode}\" \"copy-mode -M\" \"send-keys -M\"" "copy-mode -M"
bind-key -n MouseDrag1Border resize-pane -M

# Fix mouse wheel for applications using legacy scroll.
# See https://github.com/tmux/tmux/issues/1320#issuecomment-381952082.
bind -n 'WheelUpPane' {
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
bind -n 'WheelDownPane' {
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
bind -n 'MouseDown2Pane' {
  select-pane -t=
    if -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" {
      send -M
    } {
      paste-buffer -p
    }
}

# Copy word with double click
bind -n 'DoubleClick1Pane' {
  select-pane -t=
    if -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" {
      send -M
    } {
      copy-mode -H; send -X select-word; run -d0.3; send -X copy-pipe-and-cancel
    }
}

# Copy line with triple click
bind -n 'TripleClick1Pane' {
  select-pane -t=
    if -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" {
      send -M
    } {
      copy-mode -H; send -X select-line; run -d0.3; send -X copy-pipe-and-cancel
    }
}

# Zoom/unzoom the selected pane.
bind -n 'M-DoubleClick1Pane' resize-pane -Zt=

# See: https://www.reddit.com/r/tmux/comments/j7fcr7/tiling_in_tmux_as_in_bspwm/
bind -n -N 'New pane' 'M-n' if-shell \
  "[ $(($(tmux display -p '8*#{pane_width}-20*#{pane_height}'))) -lt 0 ]" "splitw -v -c '#{pane_current_path}'" "splitw -h -c '#{pane_current_path}' "

bind -n -N 'Select window 1' 'M-1' run '${TMUX_SCRIPTS_DIR}/smart_window_select.sh 1'
bind -n -N 'Select window 2' 'M-2' run '${TMUX_SCRIPTS_DIR}/smart_window_select.sh 2'
bind -n -N 'Select window 3' 'M-3' run '${TMUX_SCRIPTS_DIR}/smart_window_select.sh 3'
bind -n -N 'Select window 4' 'M-4' run '${TMUX_SCRIPTS_DIR}/smart_window_select.sh 4'
bind -n -N 'Select window 5' 'M-5' run '${TMUX_SCRIPTS_DIR}/smart_window_select.sh 5'
bind -n -N 'Select window 6' 'M-6' run '${TMUX_SCRIPTS_DIR}/smart_window_select.sh 6'
bind -n -N 'Select window 7' 'M-7' run '${TMUX_SCRIPTS_DIR}/smart_window_select.sh 7'
bind -n -N 'Select window 8' 'M-8' run '${TMUX_SCRIPTS_DIR}/smart_window_select.sh 8'
bind -n -N 'Select window 9' 'M-9' run '${TMUX_SCRIPTS_DIR}/smart_window_select.sh 9'
bind -n -N 'Select window 10' 'M-0' run '${TMUX_SCRIPTS_DIR}/smart_window_select.sh 10'
bind -n -N 'Select next window' 'M-]' next-window
bind -n -N 'Select prev window' 'M-[' previous-window

bind -n -N 'Select pane left' 'M-h' run '${TMUX_SCRIPTS_DIR}/smart_pane_select.sh M-h L'
bind -n -N 'Select pane down' 'M-j' run '${TMUX_SCRIPTS_DIR}/smart_pane_select.sh M-j D'
bind -n -N 'Select pane up' 'M-k' run '${TMUX_SCRIPTS_DIR}/smart_pane_select.sh M-k U'
bind -n -N 'Select pane right' 'M-l' run '${TMUX_SCRIPTS_DIR}/smart_pane_select.sh M-l R'

bind -n -N 'Move pane 1' 'M-!' run '${TMUX_SCRIPTS_DIR}/smart_pane_move.sh 1'
bind -n -N 'Move pane 2' 'M-@' run '${TMUX_SCRIPTS_DIR}/smart_pane_move.sh 2'
bind -n -N 'Move pane 3' 'M-#' run '${TMUX_SCRIPTS_DIR}/smart_pane_move.sh 3'
bind -n -N 'Move pane 4' 'M-$' run '${TMUX_SCRIPTS_DIR}/smart_pane_move.sh 4'
bind -n -N 'Move pane 5' 'M-%' run '${TMUX_SCRIPTS_DIR}/smart_pane_move.sh 5'
bind -n -N 'Move pane 6' 'M-^' run '${TMUX_SCRIPTS_DIR}/smart_pane_move.sh 6'
bind -n -N 'Move pane 7' 'M-&' run '${TMUX_SCRIPTS_DIR}/smart_pane_move.sh 7'
bind -n -N 'Move pane 8' 'M-*' run '${TMUX_SCRIPTS_DIR}/smart_pane_move.sh 8'
bind -n -N 'Move pane 9' 'M-(' run '${TMUX_SCRIPTS_DIR}/smart_pane_move.sh 9'
bind -n -N 'Move pane 10' 'M-)' run '${TMUX_SCRIPTS_DIR}/smart_pane_move.sh 10'
bind -n -N 'Move pane left' 'M-H' swap-pane -s '{left-of}'
bind -n -N 'Move pane down' 'M-J' swap-pane -s '{down-of}'
bind -n -N 'Move pane up' 'M-K' swap-pane -s '{up-of}'
bind -n -N 'Move pane right' 'M-L' swap-pane -s '{right-of}'

bind -n -N 'Zoom the current pane' 'M-z' resize-pane -Z
bind -n -N 'Next layout' 'M-}' next-layout
bind -n -N 'Previous layout' 'M-{' previous-layout

bind -n -N 'Edit tmux configuration' 'M-E' run-shell \
  'tmux popup -w90% -h90% -E -d "#{pane_current_path}" ${VISUAL:-${EDITOR}} "${TMUX_CONFIG}" && tmux source "${TMUX_CONFIG}" && tmux display "Reloaded config"'
bind -n -N 'Reload the tmux configuration' 'M-R' run-shell \
  'tmux source "${TMUX_CONFIG}" && tmux display "Reloaded config"'

bind -n -N 'Show status line messages' 'M-,' show-messages
bind -n -N 'Prompt for a command' 'M-;' command-prompt
bind -n -N 'Enter copy mode' "M-\\" copy-mode
bind-key -N 'Toggle scratch window' -n "M-'" if-shell -F '#{==:#{session_name},scratch}' {
  detach-client
} {
  display-popup -d "#{pane_current_path}" -xC -yC -w 80% -h 75% -E 'tmux new-session -A -s scratch'
}
bind -n -N 'List keybindings' 'M-/' display-popup -w80 -h90% -E "tmux list-keys -N -T root | $PAGER"
