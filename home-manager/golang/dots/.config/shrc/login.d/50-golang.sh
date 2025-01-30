export GOPATH="${XDG_DATA_HOME}/go"
export GOBIN="${GOPATH}/bin"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"

[[ "${PATH}" =~ ${GOBIN} ]] || \
  export PATH="${GOBIN}:${PATH}"
