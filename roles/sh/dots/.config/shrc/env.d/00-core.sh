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
export XDG_RUNTIME_DIR="/tmp/runtimedir/${UID}" && mkdir -p "${XDG_RUNTIME_DIR}"

# System directories
export XDG_CONFIG_DIRS="/etc/xdg" && mkdir -p "${XDG_CONFIG_DIRS}"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
