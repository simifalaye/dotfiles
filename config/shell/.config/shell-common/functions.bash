# shellcheck shell=bash

#-
#  General
#-

# Usage: include <file-1> ...
include() {
  local src
  for src in "$@"; do
    # shellcheck disable=SC1090
    test -r "$src" && . "$src" || return 1
  done
}

# Usage: is_callable <cmd-1> <cmd-2> ... <cmd-n>
is_callable() {
  local cmd
  for cmd in "$@"; do
    command -v "${cmd}" >/dev/null || return 1
  done
}

# Usage: take <dir>
take() {
  dir="${1}"
  if [ -n "${dir}" ]; then
    mkdir -p "${1}" && builtin cd "${1}"
  fi
}

# Usage: backupthis <file/dir>
backupthis() {
  local item
  for item in "$@"; do
    cp -riv "${item}" "${item}"-"$(date +%Y%m%d%H%M)".backup
  done
}
