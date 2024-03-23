# vim: filetype=conf
#
# Configuration of tmux plugins.
#

#-
#  plugin setup
#-

# Install tpm if not installed
TMUX_PLUGIN_MANAGER_PATH="${TMUX_DATA_DIR}/plugins"
TPM_REPO="https://github.com/tmux-plugins/tpm"
TPM_DIR="${TMUX_PLUGIN_MANAGER_PATH}/tpm"
if "test ! -d ${TPM_DIR}" \
     "run 'git clone ${TPM_REPO} ${TPM_DIR} && ${TPM_DIR}/bin/install_plugins'";

 # List of plugins
set -g @tpm_plugins '                \
  tmux-plugins/tpm                   \
  tmux-plugins/tmux-logging          \
  tmux-plugins/tmux-resurrect        \
  tmux-plugins/tmux-yank             \
  fcsonline/tmux-thumbs              \
'

#-
#  tmux-logging
#-

# Key bindings for tmux-logging.
set -g @logging_key 'l'
set -g @screen-capture-key 'M-l'
set -g @save-complete-history-key 'M-L'

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
set -g @resurrect-dir "${TMUX_CACHE_DIR}/resurrect"

# Capture and restore pane contents.
set -g @resurrect-capture-pane-contents on

# Key bindings for tmux-resurrect.
set -g @resurrect-save 'M-s'
set -g @resurrect-restore 'M-r'

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

# Override copy to use osc52 in SSH
if-shell -b '[ -n "${SSH_TTY}" ]' {
  set -g @override_copy_command "tmux load-buffer -w -"
}

#-
#  tmux-thumbs
#-

# Override copy to use osc52 in SSH
if-shell -b '[ -n "${SSH_TTY}" ]' {
  set -g @thumbs-command "tmux set-buffer -w -- {} && tmux display-message \"Copied {}\""
  set -g @thumbs-upcase-command "tmux set-buffer -w -- {} && tmux paste-buffer && tmux display-message \"Copied {}\""
  set -g @thumbs-multi-command "tmux set-buffer -w -- {} && tmux paste-buffer && tmux send-keys ' ' && tmux display-message \"Copied multiple items!\""
}

# Load thumbs
if-shell "test -f ${TMUX_PLUGIN_MANAGER_PATH}/tmux-thumbs/tmux-thumbs.tmux" {
  run-shell "${TMUX_PLUGIN_MANAGER_PATH}/tmux-thumbs/tmux-thumbs.tmux"
}

#-
#  Load plugins
#-

# Initialize the plugin manager (should be last in the config file).
run -b '${TPM_DIR}/tpm'
