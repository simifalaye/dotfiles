# vim: filetype=zsh

# Load common shell files
. "${HOME}/.config/shell-common/env.bash"

#-
#  General
#-

# Move zsh config files to XDG base dir
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# XDG paths for zsh.
export ZDATADIR=${ZDATADIR:-${XDG_DATA_HOME:-$HOME/.local/share}/zsh} && mkdir -p ${ZDATADIR}
export ZCACHEDIR=${ZCACHEDIR:-${XDG_CACHE_HOME:-$HOME/.cache}/zsh} && mkdir -p ${ZCACHEDIR}

# Setup location to store plugins
export ZPLUGDIR="${ZDATADIR}/plugins" && mkdir -p ${ZPLUGDIR}

# Add your functions to your $fpath, so you can autoload them.
fpath=(
  ${ZDOTDIR}/functions
  $fpath
  ${ZDATADIR}/site-functions
)

# Ensure that path arrays do not contain duplicates.
typeset -gU \
  CDPATH cdpath \
  FPATH fpath \
  MANPATH manpath \
  MODULE_PATH module_path \
  MAILPATH mailpath \
  PATH path

# Skip the not really helping Ubuntu global compinit
# NOTE: Must be in .zshenv file
skip_global_compinit=1
