# shellcheck shell=zsh

if ! is_callable starship; then
    curl -sS https://starship.rs/install.sh | sh
fi

eval "$(starship init zsh)"
