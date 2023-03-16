# shellcheck shell=bash
#
# This file is sourced automatically by xsh if the current shell is `bash`
#
# It should merely register the modules to be loaded for each runcom:
# env, login, interactive and logout.
# The order in which the modules are registered defines the order in which
# they will be loaded. Try `xsh help` for more information.
#

# Load core config
xsh module core -s posix
xsh module core

# Load application modules that have no requirements
xsh module base16 interactive
xsh module browser interactive:env
xsh module cheat interactive
xsh module editor interactive:env
xsh module exa interactive
xsh module fzf interactive
xsh module pager interactive:env
xsh module ripgrep interactive
xsh module tmux interactive
xsh module trash interactive:logout
xsh module wsl login
xsh module zk interactive
xsh module zoxide interactive:login
