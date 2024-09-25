# Set status mode
set -g @tmux_status_mode "PANE"
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
bind -n -N 'Mode: Resize' 'M-r' source "${TMUX_MODES_DIR}/resize.tmux"
bind -n -N 'Mode: Session' 'M-s' source "${TMUX_MODES_DIR}/session.tmux"
bind -n -N 'Mode: Window' 'M-w' source "${TMUX_MODES_DIR}/window.tmux"

# Quit
bind -n -N 'Quit' 'M-p' source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'Quit' 'Escape' source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'Quit' 'Enter' source "${TMUX_MODES_DIR}/main.tmux"

bind -n -N 'New' 'n' split-window -h \; source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'Split below' 's' split-window -v -c "#{pane_current_path}" \; source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'Split right' 'v' split-window -h -c "#{pane_current_path}" \; source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'Select left' 'h' select-pane -L
bind -n -N 'Select down' 'j' select-pane -D
bind -n -N 'Select up' 'k' select-pane -U
bind -n -N 'Select Right' 'l' select-pane -R
bind -n -N 'Select last' 'p' last-pane
bind -n -N 'Mark' 'm' select-pane -m
bind -n -N 'Clear mark' 'M' select-pane -M
bind -n -N 'Break to new window' 'b' break-pane
bind -n -N 'Join marked with current' 'y' join-pane
bind -n -N 'Kill' 'x' kill-pane \; source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'Zoom' 'z' resize-pane -Z \; source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'List keybindings' 'M-/' display-popup -w80 -h90% -E "tmux list-keys -N -T root | $PAGER"
