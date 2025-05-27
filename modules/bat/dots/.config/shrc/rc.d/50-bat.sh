if command -v batcat >/dev/null; then
  alias bat="batcat -p --theme='base16-256'"
else
  alias bat="bat -p --theme='base16-256'"
fi
alias cat="bat"
