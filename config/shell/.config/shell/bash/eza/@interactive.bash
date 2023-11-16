# shellcheck shell=bash

if ! is_callable exa; then
	return 1
fi

export EZA_COLORS='da=1;34:gm=1;34'

# Quick switch to opt-in git support.
alias eza='eza --git'

# Override original aliases with similar, yet improved behavior.
alias ls='eza --group-directories-first' # list directories first
alias ll='ls -lh' # list human readable sizes
alias l='ll -A' # list human readable sizes, all files
alias lr='ll -T' # list human readable sizes, recursively
alias lx='ll --sort=ext' # list sorted by extension (GNU only)
alias lk='ll --sort=size' # list sorted by size, largest last
alias lt='ll --sort=mod' # list sorted by modification time, most recent last
