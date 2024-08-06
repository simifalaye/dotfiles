export TINTY_DATA_DIR="${XDG_DATA_HOME}/tinted-theming/tinty"
export TINTY_SCHEME_FILE="${TINTY_DATA_DIR}/current_scheme"

# Tinty isn't able to apply environment variables to your shell due to
# the way shell sub-processes work. This is a work around by running
# Tinty through a function and then executing the shell scripts.
tinty_source_shell_theme() {
  tinty -c ~/.config/tinty/config.toml "$@"
  subcommand="$1"

  if [ "$subcommand" = "apply" ] || [ "$subcommand" = "init" ]; then
    scripts=$(find "${TINTY_DATA_DIR}" -maxdepth 1 -type f -name "*.sh")
    while IFS= read -r script; do
      # shellcheck source=/dev/null
      . "$script"
    done <<< "$scripts"
  fi

  unset subcommand
}

if command -v tinty >/dev/null && ((SHLVL == 1)); then
  tinty_source_shell_theme "init"

  alias tinty=tinty_source_shell_theme
fi
