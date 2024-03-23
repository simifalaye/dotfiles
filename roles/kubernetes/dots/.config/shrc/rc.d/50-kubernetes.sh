# Lazily load completion to speed up zsh startup time
# https://stackoverflow.com/a/48202907/1157536
kubectl () {
  command kubectl "$*"
  if [[ -z $KUBECTL_COMPLETE ]]
  then
    # shellcheck source=/dev/null
    source <(command kubectl completion zsh)
    KUBECTL_COMPLETE=1
  fi
}

# Aliases
alias k='kubectl'
