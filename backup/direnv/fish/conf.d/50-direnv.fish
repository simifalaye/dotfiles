if ! command -v direnv > /dev/null
    return
end

if status --is-interactive
    direnv hook fish | source
end
