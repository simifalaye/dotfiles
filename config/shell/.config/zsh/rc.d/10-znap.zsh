#
# The plugin manager module
#

local znap_dir="${ZDATADIR}/znap"
local znap="${znap_dir}/znap.zsh"

# Auto-install Znap if it's not there yet.
if ! [[ -r ${znap} ]]; then
  git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git ${znap_dir}
fi

# Load Znap.
# NOTE: Znap will run compinit (DON'T run in rest of config)
. $znap
