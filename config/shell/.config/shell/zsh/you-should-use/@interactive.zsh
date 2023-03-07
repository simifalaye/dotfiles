# shellcheck shell=zsh

if (( ! $+functions[zi] )); then
    return 1
fi

# Setup you-should-use
zi light-mode wait'0b' lucid for \
  id-as'plugin/zsh-you-should-use' \
  depth=1 reset nocompile'!' \
  @MichaelAquilina/zsh-you-should-use
