# Set status mode
set -g @tmux_status_mode "LOCKED"
set -g @tmux_status_mode_bg "red"

# Unbind unneccesary tables
unbind -T root -a

# Reset input state
run-shell "${TMUX_SCRIPTS_DIR}/input_reset.sh"
set-hook -gu client-attached "select-pane -d"
set-hook -gu client-focus-in "select-pane -d"
set-hook -gu window-pane-changed "select-pane -d"
set-hook -gu session-window-changed "select-pane -d"

bind -n -N 'Unlock' 'M-g' source "${TMUX_MODES_DIR}/main.tmux"
