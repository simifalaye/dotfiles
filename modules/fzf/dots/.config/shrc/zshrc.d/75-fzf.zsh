(( $+commands[fzf] )) || return 0

# Load fzf shell integration
if (( $+commands[znap] )); then
  znap eval fzf-shell 'fzf --zsh'
else
  eval "$(fzf --zsh)"
fi

# #
# # fzf-tab plugin
# #
#
# # Setup fzf completions
# zstyle ':completion:*' menu no
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
# zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
#
# # Load plugin
# if (( $+functions[znap] )); then
#   znap source Aloxaf/fzf-tab
# fi
