# shellcheck shell=sh
#
# This file is sourced automatically by xsh if the current shell has no
# dedicated initialization file
#
# It should merely register the modules to be loaded for each runcom:
# env, login, interactive and logout.
# The order in which the modules are registered defines the order in which
# they will be loaded. Try `xsh help` for more information.
#

# Load core config
xsh module core

# Load application modules that have no requirements
xsh module calc login
xsh module golang login
xsh module node login
xsh module python login
xsh module rustlang login
xsh module tig login
