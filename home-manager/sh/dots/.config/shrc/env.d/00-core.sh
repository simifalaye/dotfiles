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

# Functions to help us manage paths.  Second argument is the name of the
# path variable to be modified (default: PATH)
# path_remove () {
#   local IFS=':'
#   local NEWPATH
#   local DIR
#   local PATH_VAR=${2:-PATH}
#   for DIR in ${!PATH_VAR} ; do
#     if [ "$DIR" != "$1" ] ; then
#       NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
#     fi
#   done
#   export "$PATH_VAR"="$NEWPATH"
# }
# path_prepend () {
#   pathremove "$1" "$2"
#   local PATH_VAR=${2:-PATH}
#   export "$PATH_VAR"="$1${!PATH_VAR:+:${!PATH_VAR}}"
# }
# path_append () {
#   pathremove "$1" "$2"
#   local PATH_VAR=${2:-PATH}
#   export "$PATH_VAR"="${!PATH_VAR:+${!PATH_VAR}:}$1"
# }

# Usage: indirect_expand PATH -> $PATH
indirect_expand () {
    env | sed -n "s/^$1=//p"
}

# Usage: path_remove /path/to/bin [PATH]
# Eg, to remove ~/bin from $PATH
#     path_remove ~/bin PATH
path_remove () {
    local IFS=':'
    local newpath
    local dir
    local var=${2:-PATH}
    # Bash has ${!var}, but this is not portable.
    for dir in $(indirect_expand "$var"); do
        IFS=''
        if [ "$dir" != "$1" ]; then
            newpath=$newpath:$dir
        fi
    done
    export "$var"="${newpath#:}"
}

# Usage: path_prepend /path/to/bin [PATH]
# Eg, to prepend ~/bin to $PATH
#     path_prepend ~/bin PATH
path_prepend () {
    [ -d "${1}" ] || return
    # if the path is already in the variable,
    # remove it so we can move it to the front
    path_remove "$1" "$2"
    local var="${2:-PATH}"
    local value
    value=$(indirect_expand "$var")
    export "${var}"="${1}${value:+:${value}}"
}

# Usage: pathappend /path/to/bin [PATH]
# Eg, to append ~/bin to $PATH
#     pathappend ~/bin PATH
path_append () {
    [ -d "${1}" ] || return
    path_remove "${1}" "${2}"
    local var=${2:-PATH}
    local value
    value=$(indirect_expand "$var")
    export "$var"="${value:+${value}:}${1}"
}
