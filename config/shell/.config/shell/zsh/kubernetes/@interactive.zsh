# shellcheck shell=zsh

if ! is_callable kubectl; then
  return 1
fi

# Setup aliases
alias k='kubectl'

# Setup completions
KUBE_COMPLETIONS="${ZDATADIR}/kubectl_completions"
if [ ! -f "${KUBE_COMPLETIONS}" ]; then
  kubectl completion zsh > ${KUBE_COMPLETIONS}
fi
source ${KUBE_COMPLETIONS}
