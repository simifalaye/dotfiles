# Set status mode
set -g @tmux_status_mode "SESSION"
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
bind -n -N 'Mode: Window' 'M-w' source "${TMUX_MODES_DIR}/window.tmux"

# Quit
bind -n -N 'Quit' 'M-s' source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'Quit' 'Escape' source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'Quit' 'Enter' source "${TMUX_MODES_DIR}/main.tmux"

bind -n -N 'Customize options' 'c' customize-mode -Z \; source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'Detach' 'd' detach-client
bind -n -N 'Kill' 'x' confirm-before -p "kill-session #S? (y/n)" kill-session
bind -n -N 'Select last' 's' switch-client -l \; source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'Select next' 'l' switch-client -n
bind -n -N 'Select prev' 'h' switch-client -p
bind -n -N 'Select interactively' 'Space' choose-tree -Zs \; source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'Create a new session' 'n' command-prompt { new-session -s "%%" } \; source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'Rename the current session' 'r' command-prompt -I "#S" { rename-session "%%" } \; source "${TMUX_MODES_DIR}/main.tmux"
bind -n -N 'List keybindings' 'M-/' display-popup -w80 -h90% -E "tmux list-keys -N -T root | $PAGER"
