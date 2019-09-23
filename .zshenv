# Source global definitions
test -r ~/.shell-profile && . ~/.shell-profile

# Move ZDOTDIR from $HOME to reduce dotfile pollution.
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZGEN_DIR="$XDG_CACHE_HOME/zgen"
export ZSH_CACHE="$XDG_CACHE_HOME/zsh"

# Set vendor completions path
fpath=(/usr/share/zsh/vendor-completions/ $fpath)
