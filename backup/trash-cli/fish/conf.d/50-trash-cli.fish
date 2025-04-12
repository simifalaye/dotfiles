if ! command -v trash >/dev/null
    return
end

if status --is-interactive
    # This is not recommended by the author:
    # https://github.com/andreafrancia/trash-cli#can-i-alias-rm-to-trash-put
    # alias rm='trash'

    # Hitting enter twice will trash, enter + y will permanently delete.
    # Note that this approach also disables the trash when using `sudo`.
    if abbr -q rm
        abbr -e rm
    end
    function rm
        echo -n 'Delete permanently? [y/N] '
        read -l confirm
        switch $confirm
            case Y y
                command rm -rv $argv
            case '' N n
                trash $argv
        end
    end

    # Restore a trashed file
    abbr -a rmr trash-restore

    # List trashed files.
    abbr -a rml trash-list
end

function __trash_logout
    # Remove files that have been trashed more than 30 days ago
    if test -z "$TMUX"
        trash-empty -f 30
    end
end
set -a logout_functions __trash_logout
