# shellcheck shell=bash

if ! is_callable zk; then
    return 1
fi

# Set notebook dir
export ZK_NOTEBOOK_DIR="${HOME}/notes"
