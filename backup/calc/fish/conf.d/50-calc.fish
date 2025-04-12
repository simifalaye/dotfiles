if ! command -v calc >/dev/null
    return
end

if status --is-login
    set -x CALCHISTFILE "$XDG_CACHE_HOME/calc_history"
end
