#
# Directory options
#

#-
#  CD options
#-

# Perform cd to a directory if the typed command is invalid, but is a directory.
setopt AUTO_CD

# Make cd push the old directory to the directory stack.
setopt AUTO_PUSHD

autoload -Uz is-at-least && if is-at-least 5.8; then
# Don't print the working directory after a cd.
setopt CD_SILENT
fi

# Don't push multiple copies of the same directory to the stack.
setopt PUSHD_IGNORE_DUPS

# Don't print the directory stack after pushd or popd.
setopt PUSHD_SILENT

#-
#  Named directories
#-

# Create shortcuts for your favorite directories.
# Set these early, because it affects how dirs are displayed and printed.
hash -d zsh=$ZDOTDIR
# `hash -d <name>=<path>` makes ~<name> a shortcut for <path>.
# You can use this ~name anywhere you would specify a dir, not just with `cd`!
