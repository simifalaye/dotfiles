# shellcheck shell=sh

if ! is_callable rustup; then
  return 1
fi

mkdir -p "${XDG_DATA_HOME}/tig" # Needed for tig_history
