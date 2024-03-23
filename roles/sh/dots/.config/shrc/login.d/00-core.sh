#-
#  General
#-

# Prepend user binaries to PATH to allow overriding system commands.
[[ "${PATH}" =~ ${HOME}/.local/bin ]] || \
  export PATH="${HOME}/.local/bin:${PATH}"

# Wsl2
if grep -iq microsoft /proc/version; then
  # Escape path
  export PATH=${PATH// /\\ }
fi
