# shellcheck shell=sh

if ! is_callable rustup; then
  return 1
fi

export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
