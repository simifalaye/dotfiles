export PYTHONUSERBASE="${XDG_DATA_HOME}/python" && \
  mkdir -p "${PYTHONUSERBASE}"
export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python" && \
  mkdir -p "${PYTHONPYCACHEPREFIX}"
