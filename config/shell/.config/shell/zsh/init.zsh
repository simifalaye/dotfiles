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

# Load plugin manager early
# xsh module zi interactive

# Load theme early (before prompt)
xsh module -s bash base16 interactive

# Load prompt early
xsh module prompt interactive

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
xsh module -s bash exa interactive
xsh module -s bash pager interactive:env
xsh module -s bash ripgrep interactive
xsh module -s bash tmux interactive
xsh module -s bash trash interactive:logout
xsh module -s bash wsl login
xsh module -s bash zoxide interactive:login

# Load the completion system and define core ZLE widgets and bindings.
xsh module completion interactive
xsh module zle interactive # load after completion
xsh module kubernetes interactive # load after completion

# Load additional application modules that provide and bind ZLE widgets.
xsh module -s bash fzf interactive
xsh module you-should-use interactive

# Load the modules that wrap ZLE widgets after they have all been defined
xsh module syntax-highlighting interactive
xsh module history-substring-search interactive
xsh module autosuggestion interactive
