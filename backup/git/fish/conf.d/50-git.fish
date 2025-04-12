if ! command -v git > /dev/null
    return
end

if status --is-interactive
    abbr -a g "git"
end
