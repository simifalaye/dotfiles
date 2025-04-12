if ! command -v cargo >/dev/null
    return
end

if status --is-login
    set -x CARGO_HOME "$XDG_DATA_HOME/cargo"
    set -x RUSTUP_HOME "$XDG_DATA_HOME/rustup"
end
