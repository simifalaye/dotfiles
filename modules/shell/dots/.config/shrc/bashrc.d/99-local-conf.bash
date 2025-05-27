# NOTE: Load module last allow local config to override base config

# shellcheck disable=SC1091
test -r "${HOME}/.shrc.local" && . "${HOME}/.shrc.local"
# shellcheck disable=SC1091
test -r "${HOME}/.bashrc.local" && . "${HOME}/.bashrc.local"
