# shellcheck shell=sh

if ! is_callable node; then
  return 1
fi

export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export NPM_CONFIG_PREFIX="${XDG_DATA_HOME}/npm"
export NODE_REPL_HISTORY="${XDG_STATE_HOME}/node/repl_history"
mkdir -p "${NODE_REPL_HISTORY}"

# Add npm bin dir to path
path_prepend "${XDG_DATA_HOME}"/npm/bin PATH
