export TINTY_DATA_DIR="${XDG_DATA_HOME}/tinted-theming/tinty"
export TINTY_CURRENT_FILE="${TINTY_DATA_DIR}/current_scheme"

# Tinty isn't able to apply environment variables to your shell due to
# the way shell sub-processes work. This is a work around by running
# Tinty through a function and then executing the shell scripts.
tinty_source_shell_theme() {
  newer_file=$(mktemp)
  tinty $@
  subcommand="$1"

  if [ "$subcommand" = "apply" ] || [ "$subcommand" = "init" ]; then
    while read -r script; do
      # shellcheck disable=SC1090
      . "$script"
    done < <(find "${TINTY_DATA_DIR}" -maxdepth 1 -type f -name "*.sh" -newer "$newer_file")
  fi

  unset subcommand
}

if [ -n "$(command -v 'tinty')" ]; then
  if [ ! -d "${XDG_DATA_HOME}/tinted-theming/tinty" ]; then
    tinty_source_shell_theme install
  fi

  # Only run in valid term
  if [[ -z "${TMUX}" && -z "${NVIM}" && "${TERM}" != "linux" && "$(tty)" != /dev/tty[0-9]* ]]; then
    tinty_source_shell_theme "init" >/dev/null
  fi

  alias tinty=tinty_source_shell_theme
fi
