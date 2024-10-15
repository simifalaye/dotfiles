# Set status mode
set -g @tmux_status_mode "RESIZE"
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
bind -n -N 'Mode: Session' 'M-s' source "${TMUX_MODES_DIR}/session.tmux"
bind -n -N 'Mode: Window' 'M-w' source "${TMUX_MODES_DIR}/window.tmux"

# Quit
bind -n -N 'Quit' 'M-r' source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'Quit' 'Escape' source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'Quit' 'Enter' source "${TMUX_MODES_DIR}/main.tmux"

bind -n -N 'Resize left' 'h' resize-pane -L 5
bind -n -N 'Resize down' 'j' resize-pane -D 5
bind -n -N 'Resize up' 'k' resize-pane -U 5
bind -n -N 'Resize right' 'l' resize-pane -R 5
bind -n -N 'List keybindings' 'M-/' display-popup -w80 -h90% -E "tmux list-keys -N -T root | $PAGER"
