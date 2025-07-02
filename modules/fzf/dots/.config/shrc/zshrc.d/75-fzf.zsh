(( $+commands[fzf] )) || return 0
(( $+functions[znap] )) || return 0

# Load fzf shell integration
znap eval fzf-keys "fzf --zsh"
