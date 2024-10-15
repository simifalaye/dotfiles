# This is not recommended by the author:
# https://github.com/andreafrancia/trash-cli#can-i-alias-rm-to-trash-put
# alias rm='trash'

# Hitting enter twice will trash, enter + y will permanently delete.
# Note that this approach also disables the trash when using `sudo`.
function rm {
  local bye
  print -n 'delete permanently? [y/N] ' && read -rsq bye; print
  if [[ $bye == 'y' ]]; then
    command rm -rv "$@"
  else
    trash "$@"
  fi
}

# Restore a trashed file
alias rmr='trash-restore'

# List trashed files.
alias rml='trash-list'

# Remove any previously defined alias including options such as -i/-I,
# which `trash` attempts to replace.
if alias rm &> /dev/null; then
  unalias rm
fi
