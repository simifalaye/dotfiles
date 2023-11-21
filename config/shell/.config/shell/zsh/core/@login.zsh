# shellcheck shell=zsh

# XDG paths for zsh.
export ZDATADIR=${ZDATADIR:-$XDG_DATA_HOME/zsh} && mkdir -p ${ZDATADIR}
export ZCACHEDIR=${ZCACHEDIR:-$XDG_CACHE_HOME/zsh} && mkdir -p ${ZCACHEDIR}
