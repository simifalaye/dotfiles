# vim: filetype=bash
# shellcheck shell=bash
# See: https://blog.flowblok.id.au/static/images/shell-startup-actual.png

# Load common shell logout config
if [ -d "${HOME}/.config/shrc/logout.d" ]; then
  for file in "${HOME}/.config/shrc/logout.d"/*.sh; do
    # shellcheck source=/dev/null
    source "$file"
  done
fi
