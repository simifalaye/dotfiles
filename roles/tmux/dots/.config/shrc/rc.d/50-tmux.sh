# Automatically start/attach to tmux. Possible values are:
# - local   enable when starting zsh in a local terminal.
# - remote  enable when starting zsh over a SSH connection.
# - always  both of the above.
# Set to any other value to disable.
export TMUX_AUTOSTART="${TMUX_AUTOSTART-remote}"

# Define what to do when autostarting. Possible values are:
# - background      do not prompt and run a regular shell.
# - attach          do not prompt and attach to tmux.
# - prompt          prompt to attach or run a regular shell.
# Note that the tmux server is started in the background regardless of this option.
# This is useful to be properly welcomed to the terminal while the tmux session is
# being restored, e.g. with tmux-resurrect/continuum.
export TMUX_AUTOSTART_MODE="${TMUX_AUTOSTART_MODE-prompt}"

# The name of the default created session if none are defined in the tmux config.
export TMUX_DEFAULT_SESSION="${TMUX_DEFAULT_SESSION-main}"

# Figure out the TERM to use inside tmux.
if [[ $(tput setb24 2>/dev/null) ]]; then
  export TMUX_TERM="${TERM}"
elif (( $(tput colors) >= 256 )); then
  export TMUX_TERM='tmux-256color'
else
  export TMUX_TERM='tmux'
fi

# Autostart tmux and attach to a session, if enabled and not already in tmux.
# Attempt to detect whether the terminal is started from within another application.
# In xterm (or terminals mimicking it), WINDOWID is set to 0 if the terminal is not
# running in a X window (e.g. in a KDE application).
#!/bin/sh
[[ -z "${TMUX}" && -z "${NVIM}" && "${TERM}" != "linux" && "$(tty)" != /dev/tty[0-9]* ]] && valid_term=1
[[ -n "${SSH_TTY}" && ("${TMUX_AUTOSTART}" == "always" || "${TMUX_AUTOSTART}" == "remote") ]] && \
  valid_remote=true
[[ -z "${SSH_TTY}" && ("${TMUX_AUTOSTART}" == "always" || "${TMUX_AUTOSTART}" == "local") ]] && \
  valid_local=true

if [[ -n "${valid_term}" && (-n "${valid_remote}" || -n "${valid_local}") ]]; then
  # Start the tmux server, this is only useful if a session is created in the tmux config.
  # Otherwise the server will exit immediately (unless exit-empty is turned off).
  command tmux -f "$TMUX_CONFIG" start-server

  # Create the default session if no session has been defined in tmux.conf.
  if ! tmux has-session 2>/dev/null; then
    command tmux -f "$TMUX_CONFIG" new-session -ds "$TMUX_DEFAULT_SESSION"
  fi

  # Perform the action defined by the selected autostart mode.
  attach=""
  if [[ $TMUX_AUTOSTART_MODE == 'attach' ]]; then
    attach=true
  elif [[ $TMUX_AUTOSTART_MODE == prompt* ]]; then
    # Interactively ask to enter tmux or a regular shell.
    ans="n"
    print -n ':: Attach to tmux session? [Y/n] ' && read -rsk ans; print
    [[ "${ans}" =~ ^[Yy]$ ]] && attach=true
  fi

  # Attach to the default session or to the most recently used unattached session.
  [[ -n "${attach}" ]] && exec command tmux attach-session
fi

# Convenience aliases
alias tmux='tmux -2 -f ${TMUX_CONFIG}'
alias tl="tmux ls"

# Credit: https://github.com/akinsho/dotfiles/blob/main/zsh/scripts/fzf.sh
# tm [name]: Attach session or create it if it doesn't exist
#   - If no name is provided, use fzf to select one
tm() {
  [ -n "$TMUX" ] && change="switch-client" || change="attach-session"
  if [ "$1" ]; then
    tmux "$change" -t "$1" 2>/dev/null ||
      (tmux new-session -d -s "$1" && tmux "$change" -t "$1")
  elif command -v fzf >/dev/null; then
    session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&
      tmux "$change" -t "$session" || echo "No sessions found."
  fi
}
