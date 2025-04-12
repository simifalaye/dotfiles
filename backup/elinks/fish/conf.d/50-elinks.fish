if ! command -v elinks >/dev/null
    return
end

if status --is-login
    set -x ELINKS_CONFDIR "$XDG_CONFIG_HOME/elinks"
end
