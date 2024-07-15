if (( ! $+commands[zoxide] )); then
  return
fi

# Configure zoxide
export _ZO_ECHO=1

# Load zsh zoxide plugin
eval "$(zoxide init zsh)"
