# vim: filetype=bash
# shellcheck shell=bash
# See: https://blog.flowblok.id.au/static/images/shell-startup-actual.png

# Required to enable an env file for non-login interactive shells
export BASH_ENV="${HOME}/.bashenv"

# Load common shell env config
if [ -d "${HOME}/.config/shrc/env.d" ]; then
  for file in "${HOME}/.config/shrc/env.d"/*.sh; do
    # shellcheck source=/dev/null
    source "$file"
  done
fi

# Load common shell login config
if [ -d "${HOME}/.config/shrc/login.d" ]; then
  for file in "${HOME}/.config/shrc/login.d"/*.sh; do
    # shellcheck source=/dev/null
    source "$file"
  done
fi

# Load interactive config if this is an interactive shell
if [[ $- == *i* ]]; then
  # Load common shell interactive config
  if [ -d "${HOME}/.config/shrc/rc.d" ]; then
    for file in "${HOME}/.config/shrc/rc.d"/*.sh; do
      # shellcheck source=/dev/null
      source "$file"
    done
  fi

  # Load bash shell interactive config
  if [ -d "${HOME}/.config/shrc/bashrc.d" ]; then
    for file in "${HOME}/.config/shrc/bashrc.d"/*.bash; do
      # shellcheck source=/dev/null
      source "$file"
    done
  fi
fi
