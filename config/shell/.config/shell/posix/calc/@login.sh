# shellcheck shell=sh

if ! is_callable calc; then
  return 1
fi

export CALCHISTFILE="${XDG_CACHE_HOME}/calc_history"
