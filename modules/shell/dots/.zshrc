# vim: filetype=zsh
# shellcheck shell=zsh
# See: https://blog.flowblok.id.au/static/images/shell-startup-actual.png

# Load common shell interactive config
if [ -d "${HOME}/.config/shrc/rc.d" ]; then
  for file in "${HOME}/.config/shrc/rc.d"/*.sh; do
    # shellcheck source=/dev/null
    source "$file"
  done
fi

# Load zsh shell interactive config
if [ -d "${HOME}/.config/shrc/zshrc.d" ]; then
  for file in "${HOME}/.config/shrc/zshrc.d"/*.zsh; do
    # shellcheck source=/dev/null
    source "$file"
  done
fi
