# shellcheck shell=zsh

# XDG paths for zsh.
export ZDATADIR=${ZDATADIR:-$XDG_DATA_HOME/zsh} && mkdir -p ${ZDATADIR}
export ZCACHEDIR=${ZCACHEDIR:-$XDG_CACHE_HOME/zsh} && mkdir -p ${ZCACHEDIR}

#-
#  Plugin support
#-

export ZPLUGDIR="${ZDATADIR}/plug" && mkdir -p ${ZPLUGDIR}

function zcompile-many() {
  local f
  for f; do
    zcompile -R -- "$f".zwc "$f"
  done
}
