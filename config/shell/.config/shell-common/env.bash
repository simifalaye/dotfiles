# shellcheck shell=bash

#-
#  Config helpers
#-

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
export XDG_RUNTIME_DIR="/run/user/$(id -u)"

# System directories
export XDG_CONFIG_DIRS="/etc/xdg" && mkdir -p "${XDG_CONFIG_DIRS}"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"

#-
#  General
#-

export NAME="Simi Falaye"
export EMAIL="simifalaye1@gmail.com"

# X server auth
export ICEAUTHORITY="${XDG_CACHE_HOME}/ICEauthority"
[ -f "$XDG_CACHE_HOME/Xauthority" ] && \
  export XAUTHORITY="${XDG_CACHE_HOME}/Xauthority"

# Set the browser
if [ -n "${DISPLAY}" ]; then
  export BROWSER=firefox
else
  export BROWSER=elinks
fi

# Set the default editor.
if command -v nvim >/dev/null; then
  export EDITOR='nvim'
elif command -v vi >/dev/null; then
  export EDITOR='vi'
elif command -v nano >/dev/null; then
  export EDITOR='nano'
fi
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

# Prepend user binaries to PATH to allow overriding system commands.
[[ "${PATH}" =~ ${HOME}/.local/bin ]] || \
  export PATH="${HOME}/.local/bin:${PATH}"

# Wsl2

if grep -iq microsoft /proc/version; then
  # Required: Enables copy/paste (need to specify ip of wsl 2 VM)
  # DON'T USE WHEN RUNNING win32yank.exe
  # export DISPLAY="$(/sbin/ip route | awk '/default/ { print $3 }'):0"
  export LS_COLORS="ow=01;36;40"
  export LIBGL_ALWAYS_INDIRECT=1
  # pam_env
  export XDG_RUNTIME_DIR=/tmp/runtimedir
  export RUNLEVEL=3
  # Escape path
  export PATH=${PATH// /\\ }
  # Use explorer.exe for browser
  export BROWSER="/mnt/c/Windows/explorer.exe"
fi

#-
#  App: Calc
#-

export CALCHISTFILE="${XDG_CACHE_HOME}/calc_history"

#-
#  App: Elinks
#-

export ELINKS_CONFDIR="${XDG_CONFIG_HOME}/elinks"

#-
#  App: Golang
#-

export GOCACHE="${XDG_CACHE_HOME}/go-build"
export GOPATH="${XDG_DATA_HOME}/go"

#-
#  App: Node/npm
#-

export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export NPM_CONFIG_PREFIX="${XDG_DATA_HOME}/npm"
export NODE_REPL_HISTORY="${XDG_STATE_HOME}/node/repl_history" && \
  mkdir -p "${NODE_REPL_HISTORY}"

#-
#  Python
#-

export PYTHONUSERBASE="${XDG_DATA_HOME}/python" && \
  mkdir -p "${PYTHONUSERBASE}"
export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python" && \
  mkdir -p "${PYTHONPYCACHEPREFIX}"
[[ "${PATH}" =~ ${XDG_DATA_HOME}/python/bin ]] || \
  export PATH="${XDG_DATA_HOME}/python/bin:${PATH}"

#-
#  App: Rust
#-

export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
[[ "${PATH}" =~ "${CARGO_HOME}/bin" ]] || \
  export PATH="${CARGO_HOME}/bin:${PATH}"

#-
#  App: Tig
#-

mkdir -p "${XDG_DATA_HOME}/tig" # Needed for tig_history

#-
#  App: Tmux
#-

# Path to the root tmux config file.
# Using this will bypass the system-wide configuration file, if any.
export TMUX_CONFIG="${XDG_CONFIG_HOME}/tmux/tmux.conf"

#-
#  App: Wget
#-

export WGETRC="${XDG_CONFIG_HOME}/wget/config"
mkdir -p "${XDG_CONFIG_HOME}/wget"
