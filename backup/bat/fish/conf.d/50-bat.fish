if ! command -v bat >/dev/null
    return
end

if status --is-login
    set -x BAT_PAGER 'less -F'
end

if status --is-interactive
    abbr -a bat "bat -p --theme='base16-256'"
    abbr -a cat bat
end
