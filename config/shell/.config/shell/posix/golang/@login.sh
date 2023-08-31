# shellcheck shell=sh

if ! is_callable go; then
  return 1
fi

export GOCACHE="${XDG_CACHE_HOME}/go-build"
export GOPATH="${XDG_DATA_HOME}/go"
