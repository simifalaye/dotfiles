if ! command -v go >/dev/null
    return
end

if status --is-login
    set -x GOPATH "$XDG_DATA_HOME/go"
    set -x GOBIN "$GOPATH/bin"
    set -x GOMODCACHE "$XDG_CACHE_HOME/go/mod"
    if not contains -- $GOBIN $PATH
        set -x PATH $GOBIN $PATH
    end
end
