# vim: filetype=zsh
# shellcheck shell=zsh
# See: https://blog.flowblok.id.au/static/images/shell-startup-actual.png

# UNCOMMENT to enable profiling
# zmodload zsh/zprof

# Optionally enable performance timing on each source file
# Can be run using: RUN_PROF=1 zsh -cli exit
ssource() {
  local file="$1"
  if [ -n "${RUN_PROF}" ]; then
    local start end elapsed
    start=$(date +%s.%N)
    # shellcheck source=/dev/null
    source "${file}"
    end=$(date +%s.%N)
    elapsed=$(printf "%.3f" "$(echo "${end} - ${start}" | bc)")
    echo "${elapsed} seconds sourcing ${file}"
  else
    source "${file}"
  fi
}

# Load common shell interactive config
if [ -d "${HOME}/.config/shrc/rc.d" ]; then
  for file in "${HOME}/.config/shrc/rc.d"/*.sh; do
    ssource "$file"
  done
fi

# Load zsh shell interactive config
if [ -d "${HOME}/.config/shrc/zshrc.d" ]; then
  for file in "${HOME}/.config/shrc/zshrc.d"/*.zsh; do
    ssource "$file"
  done
fi

unfunction ssource

# UNCOMMENT to enable profiling
# zprof
