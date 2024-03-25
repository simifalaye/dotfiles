#-
#  XDG base directory ENV
#  References:
#  * https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
#  * https://wiki.archlinux.org/index.php/XDG_Base_Directory
#-

# User directories
export XDG_CONFIG_HOME="${HOME}/.config" && mkdir -p "${XDG_CONFIG_HOME}"
export XDG_CACHE_HOME="${HOME}/.cache" && mkdir -p "${XDG_CACHE_HOME}"
export XDG_DATA_HOME="${HOME}/.local/share" && mkdir -p "${XDG_DATA_HOME}"
export XDG_STATE_HOME="${HOME}/.local/state" && mkdir -p "${XDG_STATE_HOME}"
uid="$(id -u)" && export XDG_RUNTIME_DIR="/run/user/${uid}"

# System directories
export XDG_CONFIG_DIRS="/etc/xdg" && mkdir -p "${XDG_CONFIG_DIRS}"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"

#-
#  General
#-

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
  export LS_COLORS="ow=01;36;40"
  export LIBGL_ALWAYS_INDIRECT=1
  # pam_env
  export XDG_RUNTIME_DIR=/tmp/runtimedir
  export RUNLEVEL=3
  # Use explorer.exe for browser
  export BROWSER="/mnt/c/Windows/explorer.exe"
fi
