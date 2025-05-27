if ! test -d "${HOMEBREW_PREFIX}"; then
  return
fi

fpath+="${HOMEBREW_PREFIX}/share/zsh/site-functions"
