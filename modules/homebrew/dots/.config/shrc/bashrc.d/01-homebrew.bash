if ! test -d "${HOMEBREW_PREFIX}"; then
  return
fi

if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
  # shellcheck source=/dev/null
  source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
else
  for comp in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
    # shellcheck source=/dev/null
    [[ -r "${comp}" ]] && source "${comp}"
  done
fi
