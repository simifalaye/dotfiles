# TODO: Remove when new zellij version is released
if test -x "${HOME}/.local/bin/zellij"; then
  # shellcheck disable=SC2139
  alias zellij="${HOME}/.local/bin/zellij"
fi

#
# Autostart
#

# Automatically start/attach to zellij. Possible values are:
# - local   enable when starting zsh in a local terminal.
# - remote  enable when starting zsh over a SSH connection.
# - always  both of the above.
# Set to any other value to disable.
export ZELLIJ_AUTOSTART="${ZELLIJ_AUTOSTART-}"

# Define what to do when autostarting. Possible values are:
# - background      do not prompt and run a regular shell.
# - attach          do not prompt and attach to zellij.
# - prompt          prompt to attach or run a regular shell.
export ZELLIJ_AUTOSTART_MODE="${ZELLIJ_AUTOSTART_MODE-prompt}"

# The name of the default created session if none are defined in the zellij config.
export ZELLIJ_DEFAULT_SESSION="${ZELLIJ_DEFAULT_SESSION-main}"

# Check early exit
if test -z "${ZELLIJ_AUTOSTART}"; then
  return
fi

# Autostart zellij and attach to a session, if enabled and not already in zellij.
# Attempt to detect whether the terminal is started from within another application.
# In xterm (or terminals mimicking it), WINDOWID is set to 0 if the terminal is not
# running in a X window (e.g. in a KDE application).
#!/bin/sh
[[ -z "${ZELLIJ}" && -z "${NVIM}" && -z "${IN_ZELLIJ}" && "${TERM}" != "linux" && "$(tty)" != /dev/tty[0-9]* ]] && valid_term=true
[[ -n "${SSH_TTY}" && ("${ZELLIJ_AUTOSTART}" == "always" || "${ZELLIJ_AUTOSTART}" == "remote") ]] && valid_remote=true
[[ -z "${SSH_TTY}" && ("${ZELLIJ_AUTOSTART}" == "always" || "${ZELLIJ_AUTOSTART}" == "local") ]] && valid_local=true

if [[ -n "${valid_term}" && (-n "${valid_remote}" || -n "${valid_local}") ]]; then
  # Perform the action defined by the selected autostart mode.
  attach=""
  if [[ $ZELLIJ_AUTOSTART_MODE == 'attach' ]]; then
    attach=true
  elif [[ $ZELLIJ_AUTOSTART_MODE == prompt* ]]; then
    # Interactively ask to enter zellij or a regular shell.
    ans="n"
    print -n ':: Attach to zellij session? [Y/n] ' && read -rsk ans; print
    [[ "${ans}" =~ ^[Yy]$ ]] && attach=true
  fi

  # Attach to the default session or to the most recently used unattached session.
  [[ -n "${attach}" ]] && exec command zellij attach -c "${ZELLIJ_DEFAULT_SESSION}"
fi
