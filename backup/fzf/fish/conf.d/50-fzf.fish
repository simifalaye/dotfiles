if ! command -v fzf >/dev/null
    return
end

if status --is-login
    # Setup basic options
    set -x FZF_DEFAULT_OPTS '\
    --reverse \
    --no-mouse \
    --cycle \
    --layout=default \
    --bind ctrl-h:backward-kill-word \
    --bind ctrl-u:clear-query \
    --bind ctrl-k:kill-line \
    --bind ctrl-space:toggle-out \
    --bind ctrl-a:toggle-all \
    '

    # Use fd if available
    if command -v fd >/dev/null
        set -x FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
        set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
        set -x FZF_FILES_COMMAND "$FZF_DEFAULT_COMMAND --type f"
        set -x FZF_DIRS_COMMAND "$FZF_DEFAULT_COMMAND --type d"
    end
end

if status --is-interactive
    # Edit Git: Edit git files in current dir OR yadm if not in git dir
    function eg
        if git rev-parse --git-dir >/dev/null 2>&1
            git ls-files | fzf -m --preview "cat {}" | xargs "$EDITOR"
        else if command -v yadm >/dev/null
            yadm ls-files | fzf -m --preview "cat {}" | xargs "$EDITOR"
        else
            echo "Not in git dir" && return
        end
    end

    # Load bindings
    fzf --fish | source
end
