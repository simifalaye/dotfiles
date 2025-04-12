if ! command -v python >/dev/null and ! command -v python3 >/dev/null
    return
end

# Move python files to xdg base directory spec
set -x PYTHONUSERBASE "$XDG_DATA_HOME/python" && mkdir -p "$PYTHONUSERBASE"
set -x PYTHONPYCACHEPREFIX "$XDG_CACHE_HOME/python" && mkdir -p "$PYTHONPYCACHEPREFIX"
set -x PYTHON_HISTORY "$PYTHONUSERBASE/history" # python >= 3.13
