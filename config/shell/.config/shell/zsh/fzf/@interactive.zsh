# shellcheck shell=zsh

if ! is_callable fzf; then
  return 1
fi

# Load bash module
xsh load fzf -s bash

#-
#  Completions
#-

# Add fzf-completion widget.
fzf_completion=(
  /usr/share/doc/fzf/examples/completion.zsh
  ${HOMEBREW_PREFIX}/opt/fzf/shell/completion.zsh(N)
  ${XDG_DATA_HOME}/fzf/completion.zsh(N)
  /usr/share/fzf/completion.zsh(N)
)
if [[ -r $fzf_completion[1] ]]; then
  # Load completions
  source $fzf_completion[1]
  source ${0:h}/completion.zsh

  # Use a dedicated key instead of a trigger sequence for fuzzy completion.
  FZF_COMPLETION_TRIGGER=''
  bindkey "$key_info[Control]F" fzf-completion
  bindkey "$key_info[Control]I" "$fzf_default_completion"

  # Automatically select single matches.
  FZF_COMPLETION_OPTS="--select-1"
  # Add aliases to commands accepting directories.
  FZF_COMPLETION_DIR_COMMANDS=(cd pushd rmdir rmd)
fi

#-
#  Keys
#-

# Additional ZLE widgets.
source ${0:h}/widgets.zsh

bindkey "$key_info[Control]r" fzf-history
bindkey "$key_info[Control]t" fzf-files
bindkey "$key_info[Control]x$key_info[Control]g" fzf-cd
bindkey "$key_info[Control]x$key_info[Control]l" fzf-locate
