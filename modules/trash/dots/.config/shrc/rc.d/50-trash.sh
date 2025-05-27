# Trash file
command -v trash >/dev/null && alias rmm='trash'

# Restore a trashed file
command -v trash-restore >/dev/null && alias rmr='trash-restore'

# List trashed files.
command -v trash-list >/dev/null && alias rml='trash-list'
