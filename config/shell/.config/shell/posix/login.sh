# shellcheck disable=SC2148

#-
#  General ENV
#-

export NAME="Simi Falaye"
export EMAIL="simifalaye1@gmail.com"

# Define the default web browser.
if [ -n "$DISPLAY" ]; then
    export BROWSER=firefox
else
    export BROWSER=elinks
fi

# Define the default editor.
if is_callable nvim; then
    export EDITOR='nvim'
elif is_callable vim; then
    export EDITOR='vim'
elif is_callable nano; then
    export EDITOR='nano'
fi
export GIT_EDITOR="$EDITOR"
export USE_EDITOR="$EDITOR"
export VISUAL="$EDITOR"

# Define the default pager.
export PAGER='less'

#-
#  XDG base directory ENV
#  References:
#  * https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
#  * https://wiki.archlinux.org/index.php/XDG_Base_Directory
#-

# gnupg
if is_callable gnupg; then
    export GNUPGHOME="${XDG_DATA_HOME}/gnupg"
    mkdir -p "${GNUPGHOME}"
fi

# rust/cargo
if is_callable cargo; then
    export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
    export CARGO_HOME="${XDG_DATA_HOME}/cargo"
fi

# go
if is_callable go; then
    export GOCACHE=$XDG_CACHE_HOME/go-build
    export GOPATH="${XDG_DATA_HOME}/go"
fi

# node/npm
if is_callable npm; then
    export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
    export NPM_CONFIG_PREFIX="${XDG_DATA_HOME}/npm"
    export NODE_REPL_HISTORY="${XDG_STATE_HOME}/node/repl_history"
    mkdir -p "${NODE_REPL_HISTORY}"
fi

# tig
is_callable tig && mkdir -p "${XDG_DATA_HOME}/tig" # Needed for tig_history

# python
if is_callable python || is_callable python3; then
    export PYTHONUSERBASE="${XDG_DATA_HOME}/python"
    export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python"
    mkdir -p "${PYTHONUSERBASE}"
    mkdir -p "${PYTHONPYCACHEPREFIX}"
fi

# sqlite
if is_callable sqlite; then
    export SQLITE_HISTORY="${XDG_DATA_HOME}/sqlite_history"
fi

# elinks
if is_callable elinks; then
    export ELINKS_CONFDIR="${XDG_CONFIG_HOME}/elinks"
fi

# iceauth/xauth
export ICEAUTHORITY="${XDG_CACHE_HOME}/ICEauthority"
if [ -f "$XDG_CACHE_HOME/Xauthority" ]; then
    # X server auth cookie
    export XAUTHORITY="${XDG_CACHE_HOME}/Xauthority"
fi

# calc
if is_callable calc; then
    export CALCHISTFILE=${XDG_CACHE_HOME}/calc_history
fi

# wget
if is_callable wget; then
    export WGETRC="${XDG_CONFIG_HOME}/wget/config"
    mkdir -p "${XDG_CONFIG_HOME}/wget"
fi

# zoxide
if is_callable zoxide; then
    export _Z_DATA="${XDG_DATA_HOME}/z"
fi

#-
#  PATHs
#-

# Prepend user binaries to PATH to allow overriding system commands.
path_prepend "${XDG_BIN_HOME}" PATH
path_prepend "${CARGO_HOME}"/bin PATH
path_prepend "${XDG_DATA_HOME}"/npm/bin PATH
