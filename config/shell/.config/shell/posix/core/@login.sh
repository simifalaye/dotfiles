# shellcheck shell=sh

export NAME="Simi Falaye"
export EMAIL="simifalaye1@gmail.com"

#-
#  XDG base directory ENV
#  References:
#  * https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
#  * https://wiki.archlinux.org/index.php/XDG_Base_Directory
#-

# wget
export WGETRC="${XDG_CONFIG_HOME}/wget/config"
mkdir -p "${XDG_CONFIG_HOME}/wget"

# rust/cargo
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"

# go
export GOCACHE="${XDG_CACHE_HOME}/go-build"
export GOPATH="${XDG_DATA_HOME}/go"

# node/npm
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export NPM_CONFIG_PREFIX="${XDG_DATA_HOME}/npm"
export NODE_REPL_HISTORY="${XDG_STATE_HOME}/node/repl_history"
is_callable node && mkdir -p "${NODE_REPL_HISTORY}"

# tig
is_callable tig && mkdir -p "${XDG_DATA_HOME}/tig" # Needed for tig_history

# python
export PYTHONUSERBASE="${XDG_DATA_HOME}/python"
export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python"
is_callable python || is_callable python3 && {
    mkdir -p "${PYTHONUSERBASE}"
    mkdir -p "${PYTHONPYCACHEPREFIX}"
}

# sqlite
export SQLITE_HISTORY="${XDG_DATA_HOME}/sqlite_history"

# iceauth/xauth
export ICEAUTHORITY="${XDG_CACHE_HOME}/ICEauthority"
if [ -f "$XDG_CACHE_HOME/Xauthority" ]; then
    # X server auth cookie
    export XAUTHORITY="${XDG_CACHE_HOME}/Xauthority"
fi

# calc
export CALCHISTFILE="${XDG_CACHE_HOME}/calc_history"

#-
#  PATHs
#-

# Prepend additonal app binaries to PATH to allow overriding system commands.
path_prepend "${CARGO_HOME}"/bin PATH
path_prepend "${XDG_DATA_HOME}"/npm/bin PATH
