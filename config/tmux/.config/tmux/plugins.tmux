# vim: filetype=conf
#
# Configuration of tmux plugins.
#

%if "${TMUX_PLUGIN_MANAGER_PATH}"

#-
#  plugin setup
#-

# Install tpm if not installed
TPM_REPO="https://github.com/tmux-plugins/tpm"
TPM_DIR="${TMUX_PLUGIN_MANAGER_PATH}/tpm"
if "test ! -d ${TMUX_PLUGIN_MANAGER_PATH}/tpm" \
     "run 'git clone ${TPM_REPO} ${TPM_DIR} && ${TPM_DIR}/bin/install_plugins'"

#-
#  tmux-fingers
#-

set -g @plugin 'Morantron/tmux-fingers'

# Bindings and actions for tmux-fingers.
set -g @fingers-key 'M-f'
set -g @fingers-main-action  ':copy:'
set -g @fingers-ctrl-action  ':open:'
set -g @fingers-shift-action ':paste:'

#-
#  tmux-logging
#-

set -g @plugin 'tmux-plugins/tmux-logging'

# Key bindings for tmux-logging.
set -g @logging_key 'i'
set -g @screen-capture-key 'M-i'
set -g @save-complete-history-key 'M-I'

# Path for tmux-logging saved files.
set -g @logging-path '#{pane_current_path}'
set -g @screen-capture-path '#{pane_current_path}'
set -g @save-complete-history-path '#{pane_current_path}'

# Formats for tmux-logging saved files.
set -g @logging-filename 'tmux-log.#{session_name}:#{window_index}:#{pane_index}.%Y-%m-%dT%H:%M:%S.log'
set -g @screen-capture-filename 'tmux-screen.#{session_name}:#{window_index}:#{pane_index}.%Y-%m-%dT%H:%M:%S.log'
set -g @save-complete-history-filename 'tmux-history.#{session_name}:#{window_index}:#{pane_index}.%Y-%m-%dT%H:%M:%S.log'

#-
#  tmux-resurrect
#-

set -g @plugin 'tmux-plugins/tmux-resurrect'

# Save directory for tmux-resurrect.
set -g @resurrect-dir "${TMUX_STATE_DIR}/resurrect"

# Capture and restore pane contents.
set -g @resurrect-capture-pane-contents on

# Key bindings for tmux-resurrect.
set -g @resurrect-save 'M-S'
set -g @resurrect-restore 'M-R'

# Hooks for tmux-resurrect.
set -g @resurrect-hook-pre-restore-all '
  # Prevent activity notifications while restoring.
  tmux set -g monitor-activity off
'
set -g @resurrect-hook-post-restore-all '
  # Restore automatic-rename after environment restore.
  # See https://github.com/tmux-plugins/tmux-resurrect/issues/57.
  for session_window in $(tmux list-windows -a -F "#{session_name}:#{window_index}"); do \
    tmux set -t $session_window automatic-rename on;
  done;

  # Restore monitor-activity after a delay to avoid the spurious notifications.
  # NOTE If the session is started in the background, for some reason attaching after
  # monitor-activity is restored will still mark all windows with the activity flag.
  # This is the reason for the sensibly high delay.
  { sleep 15; tmux set -g monitor-activity on; } &
'

#-
#  tmux-prefix-highlight
#-

set -g @plugin 'tmux-plugins/tmux-prefix-highlight'

#-
#  tmux-yank
#-

set -g @plugin 'tmux-plugins/tmux-yank'

# Set copy command
if-shell "command -v ${TMUX_CLIPBOARD} >/dev/null" {
  set -g @override_copy_command "${TMUX_CLIPBOARD}"
}

#-
#  tmux-continuum (MUST BE LAST)
#-


set -g @plugin 'tmux-plugins/tmux-continuum'

# Restore the last saved environment automatically when tmux starts.
set -g @continuum-restore off
set -g @continuum-save-interval 10

#-
#  Load plugins
#-

# Initialize the plugin manager (should be last in the config file).
run -b ${TMUX_PLUGIN_MANAGER_PATH}/tpm/tpm

%endif
