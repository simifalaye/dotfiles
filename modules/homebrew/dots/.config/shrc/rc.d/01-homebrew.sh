# Load homebrew env
if test -x /opt/homebrew/bin/brew; then
  export HOMEBREW_PREFIX="/opt/homebrew"
elif test -x /usr/local/bin/brew; then
  export HOMEBREW_PREFIX="/usr/local/"
elif test -x /home/linuxbrew/.linuxbrew/bin/brew; then
  export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
fi

if test -d "${HOMEBREW_PREFIX}"; then
  eval "$("${HOMEBREW_PREFIX}"/bin/brew shellenv)"
fi
