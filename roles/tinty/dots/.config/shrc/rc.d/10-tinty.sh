# Tinty isn't able to apply environment variables to your shell due to
# the way shell sub-processes work. This is a work around by running
# Tinty through a function and then executing the shell scripts.
tinty_source_shell_theme() {
  tinty -c ~/.config/tinty/config.toml "$@"
  subcommand="$1"

  if [ "$subcommand" = "apply" ] || [ "$subcommand" = "init" ]; then
    tinty_data_dir="${XDG_DATA_HOME}/tinted-theming/tinty"

    scripts=$(find "$tinty_data_dir" -maxdepth 1 -type f -name "*.sh")
    while IFS= read -r script; do
      # shellcheck source=/dev/null
      . "$script"
    done <<< "$scripts"

    unset tinty_data_dir
  fi

  unset subcommand
}

# Only run for interactive shells
if [[ $- == *i* ]]; then
  if command -v tinty >/dev/null; then
    tinty_source_shell_theme "init"

    alias tinty=tinty_source_shell_theme
  fi
fi
