# Move python files to xdg base directory spec
export PYTHONUSERBASE="${XDG_DATA_HOME}/python" && \
  mkdir -p "${PYTHONUSERBASE}"
export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python" && \
  mkdir -p "${PYTHONPYCACHEPREFIX}"
export PYTHON_HISTORY="${PYTHONUSERBASE}/history" # python >= 3.13
