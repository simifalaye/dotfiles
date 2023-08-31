# shellcheck shell=sh

if ! is_callable python && ! is_callable python3; then
  return 1
fi

export PYTHONUSERBASE="${XDG_DATA_HOME}/python"
export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python"
mkdir -p "${PYTHONUSERBASE}"
mkdir -p "${PYTHONPYCACHEPREFIX}"

# Add python bin dir to path
path_prepend "${XDG_DATA_HOME}"/python/bin PATH
