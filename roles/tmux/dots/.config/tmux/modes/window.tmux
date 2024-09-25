# Set status mode
set -g @tmux_status_mode "WINDOW"
set -g @tmux_status_mode_bg "blue"

# Unbind unneccesary tables
unbind -T root -a

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

# Quit
bind -n -N 'Quit' 'M-w' source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'Quit' 'Escape' source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'Quit' 'Enter' source "${TMUX_MODES_DIR}/main.tmux"

bind -n -N 'New' 'n' new-window \; source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'Kill' 'x' kill-window \; source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'Next' 'l' next-window
bind -n -N 'Prev' 'h' previous-window
bind -n -N 'Swap right' 'L' swap-window -d -t +1
bind -n -N 'Swap left' 'H' swap-window -d -t -1
bind -n -N 'Rename' 'r' command-prompt -I "#W" { rename-window "%%" } \; source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'Select last' 'w' last-window \; source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'Select interactively' 'Space' choose-tree -Zw \; source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'Layout: even side-by-side' '|' select-layout even-horizontal
bind -n -N 'Layout: main side-by-side' "\\" select-layout main-vertical
bind -n -N 'Layout: even top-down' '_' select-layout even-vertical
bind -n -N 'Layout: main top-down' '-' select-layout main-horizontal
bind -n -N 'Layout: tiled' '+' select-layout tiled
bind -n -N 'Layout: even spread' '=' select-layout -E
bind -n -N 'Toggle activity monitoring' 'm' {
  set monitor-activity
    display 'monitor-activity #{?monitor-activity,on,off}'
} \; source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'Toggle silence monitoring' 'M' {
  if -F '#{monitor-silence}' {
    set monitor-silence 0
      display 'monitor-silence off'
  } {
    command-prompt -p "(silence interval)" -I "2" {
      set monitor-silence '%%'
        display 'monitor-silence #{monitor-silence}'
    }
  }
} \; source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'List keybindings' 'M-/' display-popup -w80 -h90% -E "tmux list-keys -N -T root | $PAGER"
