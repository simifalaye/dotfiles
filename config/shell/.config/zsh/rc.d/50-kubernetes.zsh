#
# The kubernetes module
#

# Abort if requirements are not met
(( $+commands[kubectl] )) || return 1
[[ -o interactive ]] || return 1

# Setup aliases
alias k='kubectl'

# Setup completions
KUBE_COMPLETIONS="${ZDATADIR}/kubectl_completions"
if [ ! -f "${KUBE_COMPLETIONS}" ]; then
  kubectl completion zsh > ${KUBE_COMPLETIONS}
fi
source ${KUBE_COMPLETIONS}
