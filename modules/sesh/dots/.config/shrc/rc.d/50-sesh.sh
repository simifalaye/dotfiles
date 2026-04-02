if command -v fzf >/dev/null; then
  alias s='sesh connect $(sesh list | fzf)'
else
  alias s='sess picker'
fi
