# vim: filetype=zsh
# shellcheck shell=zsh
# See: https://blog.flowblok.id.au/static/images/shell-startup-actual.png

# ZSH config path
export ZDOTDIR="${HOME}"

# XDG paths for zsh.
export ZDATADIR=${ZDATADIR:-${XDG_DATA_HOME:-$HOME/.local/share}/zsh} && mkdir -p ${ZDATADIR}
export ZCACHEDIR=${ZCACHEDIR:-${XDG_CACHE_HOME:-$HOME/.cache}/zsh} && mkdir -p ${ZCACHEDIR}

# Setup location to store plugins
export ZPLUGDIR="${ZDATADIR}/plugins" && mkdir -p ${ZPLUGDIR}

# User completions path
export ZUSERCOMP=${ZDATADIR}/completions && mkdir -p ${ZUSERCOMP}

# Add your functions to your $fpath, so you can autoload them.
fpath=(
  ${HOME}/.config/shrc/zshrc.d/functions
  ${ZUSERCOMP}
  $fpath
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

# Load common shell env config
if [ -d "${HOME}/.config/shrc/env.d" ]; then
  for file in "${HOME}/.config/shrc/env.d"/*.sh; do
    # shellcheck source=/dev/null
    source "$file"
  done
fi
