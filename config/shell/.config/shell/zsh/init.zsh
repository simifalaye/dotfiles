# shellcheck shell=zsh
#
# This file is sourced automatically by xsh if the current shell is `zsh`
#
# It should merely register the modules to be loaded for each runcom:
# env, login, interactive and logout.
# The order in which the modules are registered defines the order in which
# they will be loaded. Try `xsh help` for more information.
#

# Load core config
xsh module core -s posix
xsh module core

# Load prompt early
# xsh module prompt interactive

# Load application modules that have no requirements
xsh module -s posix calc login
xsh module -s posix golang login
xsh module -s posix node login
xsh module -s posix python login
xsh module -s posix rustlang login
xsh module -s posix tig login
xsh module -s bash browser interactive:env
xsh module -s bash cheat interactive
xsh module -s bash editor interactive:env
xsh module -s bash eza interactive
xsh module -s bash pager interactive:env
xsh module -s bash ripgrep interactive
xsh module -s bash tmux interactive:login
xsh module -s bash trash interactive:logout
xsh module -s bash wsl login
xsh module -s bash zoxide interactive:login

# Load plugin configuration (before loading plugin manager)
xsh module history-substring-search interactive
xsh module autosuggestion interactive

# Load plugin manager
# NOTE: ZLE and completion will be setup here
xsh module zim interactive:login

# Load ZLE widgets and bindings after completion (core, then apps)
xsh module zle interactive
xsh module fzf interactive

# Load the modules that wrap ZLE widgets after they have all been defined
