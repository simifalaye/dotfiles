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
if "test ! -d ${TPM_DIR}" \
     "run 'git clone ${TPM_REPO} ${TPM_DIR} && ${TPM_DIR}/bin/install_plugins'";

 # List of plugins
set -g @tpm_plugins '                \
  tmux-plugins/tpm                   \
  tmux-plugins/tmux-prefix-highlight \
  tmux-plugins/tmux-resurrect        \
  tmux-plugins/tmux-continuum        \
  tmux-plugins/tmux-yank             \
  tmux-plugins/tmux-logging          \
  fcsonline/tmux-thumbs              \
'

#-
#  tmux-thumbs
#-

# Override copy to use osc52
set -g @thumbs-command "tmux set-buffer -w -- {} && tmux display-message \"Copied {}\""
set -g @thumbs-upcase-command "tmux set-buffer -w -- {} && tmux paste-buffer && tmux display-message \"Copied {}\""
set -g @thumbs-multi-command "tmux set-buffer -w -- {} && tmux paste-buffer && tmux send-keys ' ' && tmux display-message \"Copied multiple items!\""

# Load thumbs
if-shell "test -f ${TMUX_PLUGIN_MANAGER_PATH}/tmux-thumbs/tmux-thumbs.tmux" {
  run-shell "${TMUX_PLUGIN_MANAGER_PATH}/tmux-thumbs/tmux-thumbs.tmux"
}

#-
#  tmux-logging
#-

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

# Save directory for tmux-resurrect.
set -g @resurrect-dir "${TMUX_STATE_DIR}/resurrect"

# Capture and restore pane contents.
set -g @resurrect-capture-pane-contents on

# Key bindings for tmux-resurrect.
set -g @resurrect-save 'C-s'
set -g @resurrect-restore 'C-r'

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
#  tmux-yank
#-

# Override copy to use osc52
set -g @override_copy_command "tmux load-buffer -w -"

#-
#  tmux-continuum (MUST BE LAST)
#-

# Restore the last saved environment automatically when tmux starts.
set -g @continuum-restore off
set -g @continuum-save-interval 10

#-
#  Load plugins
#-

# Initialize the plugin manager (should be last in the config file).
run -b ${TPM_DIR}/tpm

%endif
