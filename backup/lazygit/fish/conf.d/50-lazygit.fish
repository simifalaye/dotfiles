if ! command -v lazygit >/dev/null
    return
end

if status --is-interactive
    abbr -a lg lazygit
end
