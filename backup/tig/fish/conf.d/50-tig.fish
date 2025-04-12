if ! command -v tig >/dev/null
    return
end

if status --is-login
    mkdir -p "$XDG_DATA_HOME/tig" # Needed for tig_history
end
