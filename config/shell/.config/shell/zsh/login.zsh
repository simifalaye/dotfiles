# shellcheck disable=SC2148
source "${HOME}/.config/shell/posix/login.sh"

# XDG paths for zsh.
export ZDOTDIR="${ZDOTDIR:-$HOME}"
export ZDATADIR=${ZDATADIR:-$XDG_DATA_HOME/zsh} && mkdir -p ${ZDATADIR}
export ZCACHEDIR=${ZCACHEDIR:-$XDG_CACHE_HOME/zsh} && mkdir -p ${ZCACHEDIR}

#-
#  WSL 2
#-

if grep -q "microsoft" /proc/version &>/dev/null; then # WSL 2
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
