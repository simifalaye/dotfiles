# shellcheck shell=zsh

if (( ! $+functions[zi] )); then
    return 1
fi

zi lucid for pick"/dev/null" multisrc"{async,pure}.zsh" \
    id-as'plugin/pure' \
    atload"!prompt_pure_precmd" nocd \
    sindresorhus/pure
