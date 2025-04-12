if ! command -v nvim >/dev/null
    return
end

if status --is-login
    set -x EDITOR 'nvim'
    set -x GIT_EDITOR "$EDITOR"
    set -x USE_EDITOR "$EDITOR"
    set -x VISUAL "$EDITOR"

end

if status --is-interactive
    abbr -a vim nvim
end
