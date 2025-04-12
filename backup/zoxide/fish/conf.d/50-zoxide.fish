if ! command -v zoxide > /dev/null
    return
end

if status --is-interactive
    zoxide init fish | source
end
