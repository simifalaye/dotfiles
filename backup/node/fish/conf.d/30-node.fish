if ! command -v fzf > /dev/null
    return
end

# Move node files to xdg base directory spec
set -x NODE_REPL_HISTORY $XDG_DATA_HOME/node_repl_history
set -x NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/npmrc
