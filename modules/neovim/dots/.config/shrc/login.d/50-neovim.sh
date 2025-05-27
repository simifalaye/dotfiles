if test -d /opt/nvim/bin; then
  [[ "${PATH}" =~ /opt/nvim/bin ]] || \
    export PATH="/opt/nvim/bin:${PATH}"
fi

export EDITOR='nvim'
export GIT_EDITOR="$EDITOR"
export USE_EDITOR="$EDITOR"
export VISUAL="$EDITOR"
