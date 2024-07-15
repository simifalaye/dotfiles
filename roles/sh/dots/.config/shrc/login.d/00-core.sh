#-
#  General
#-

# Prepend user binaries to PATH to allow overriding system commands.
[[ "${PATH}" =~ ${HOME}/.local/bin ]] || \
  export PATH="${HOME}/.local/bin:${PATH}"

# Set the browser
if [ -n "${DISPLAY}" ]; then
  export BROWSER=firefox
else
  export BROWSER=elinks
fi

# Set the default editor.
export EDITOR='vi'
export GIT_EDITOR="$EDITOR"
export USE_EDITOR="$EDITOR"
export VISUAL="$EDITOR"

# Set the default pager
export PAGER='less'

# Set less config
export LESSHISTFILE="${XDG_STATE_HOME}/less/history"
export LESSKEY="${XDG_STATE_HOME}/less/key"
export LESSHISTSIZE=50
export LESS='-QRSMi -#.25 --no-histdups'
export SYSTEMD_LESS="$LESS"
mkdir -p "${XDG_STATE_HOME}/less" # Create less dir if not created

# Wsl2
if grep -iq microsoft /proc/version; then
  # Escape path
  export PATH=${PATH// /\\ }
  export LS_COLORS="ow=01;36;40"
  export LIBGL_ALWAYS_INDIRECT=1
  # pam_env
  export RUNLEVEL=3
  # Use explorer.exe for browser
  export BROWSER="/mnt/c/Windows/explorer.exe"
fi
