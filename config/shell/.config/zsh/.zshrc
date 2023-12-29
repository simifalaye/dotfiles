#
# This file, .zshrc, is sourced by zsh for each interactive shell session.
#
# Note: For historical reasons, there are other dotfiles, besides .zshenv and
# .zshrc, that zsh reads, but there is really no need to use those.

# Load common shell files
. "${HOME}/.config/shell-common/env.bash"
. "${HOME}/.config/shell-common/aliases.bash"
. "${HOME}/.config/shell-common/functions.bash"

# Autoload all appropriate functions from a directory.
# Usage: autoload_dir <dir>
function autoload_dir {
  local dir="$1"
  local skip_glob='^([_.]*|prompt_*_setup|*~)(-.N:t)'
  local func

  # Extended globbing is needed for listing autoloadable function directories.
  setopt local_options extended_glob

  fpath=($dir(-/FN) $fpath)
  for func in $dir/$~skip_glob; do
    autoload -Uz "$func"
  done
}

# Autoload all module functions.
autoload_dir ${ZDOTDIR}/functions

# The construct below is what Zsh calls an anonymous function; most other
# languages would call this a lambda or scope function. It gets called right
# away with the arguments provided and is then discarded.
# Here, it enables us to use scoped variables in our dotfiles.
() {
  # `local` sets the variable's scope to this function and its descendendants.
  local gitdir=~/Git  # where to keep repos and plugins

  # Load all of the files in rc.d that start with <number>- and end in `.zsh`.
  # (n) sorts the results in numerical order.
  #  <->  is an open-ended range. It matches any non-negative integer.
  # <1->  matches any integer >= 1.
  #  <-9> matches any integer <= 9.
  # <1-9> matches any integer that's >= 1 and <= 9.
  # See https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Operators
  local file
  for file in "${ZDOTDIR}"/rc.d/<->-*.zsh(n); do
    . "${file}"   # `.` is like `source`, but doesn't search your $path.
  done
} "${@}"

# $@ expands to all the arguments that were passed to the current context (in
# this case, to `zsh` itself).
# "Double quotes" ensures that empty arguments '' are preserved.
# It's a good practice to pass "$@" by default. You'd be surprised at all the
# bugs you avoid this way.

#-
#  Local config
#  NOTE: MUST BE AT THE END TO OVERRIDE
#-

test -r "${HOME}/.shrc.local" && . "${HOME}/.shrc.local"
test -r "${HOME}/.zshrc.local" && . "${HOME}/.zshrc.local"
