#-
#  Aliases
#-

# Type '-' to return to your previous dir.
alias -- -='cd -'
# '--' signifies the end of options. Otherwise, '-=...' would be interpreted as
# a flag.

# Elementary.
alias reload='exec $SHELL -l' # reload the current shell configuration
alias sudo='sudo '            # preserve aliases when running sudo
alias su='su -l'              # safer, simulate a real login

# Human readable output.
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias df='df -h' du='du -h'

# Verbose and safe file operations.
alias cp='cp -vi' mv='mv -vi' ln='ln -vi' rm='rm -vI'

# Directory listing.
alias dud='du -d1' # show total disk usage for direct subdirectories only
alias ls='ls --color=auto --group-directories-first' # list directories first
alias ll='ls -lh' # list human readable sizes
alias l='ll -A' # list human readable sizes, all files
alias lr='ll -R' # list human readable sizes, recursively
alias lx='ll -XB' # list sorted by extension (GNU only)
alias lk='ll -Sr' # list sorted by size, largest last
alias lt='ll -tr' # list sorted by modification time, most recent last

# Making/Changing directories.
alias mkdir='mkdir -pv'
alias mkd='mkdir'
alias rmd='rmdir'

# Systemd convenience.
alias sc='systemctl'
alias scu='sc --user'
alias jc='journalctl --catalog'
alias jcb='jc --boot=0'
alias jcf='jc --follow'
alias jce='jc -b0 -p err..alert'

# Simple progress bar output for downloaders by default.
alias curl='curl --progress-bar'
alias wget='wget -q --no-hsts --show-progress'

# Simple and silent desktop opener.
alias open='nohup xdg-open </dev/null >|$(mktemp --tmpdir nohup.XXXX) 2>&1'
alias o='open'

# Browser
alias browse='${BROWSER}'
alias b='browse'

# Editor
alias edit='${VISUAL:-${EDITOR}}'
alias e='edit'

# Pager
alias p='${PAGER}'
alias more='less'

#-
#  Functions
#-

# Usage: include <file-1> ...
include() {
  local src
  for src in "$@"; do
    # shellcheck disable=SC1090
    test -r "$src" && . "$src" || return 1
  done
}

# Usage: is_callable <cmd-1> <cmd-2> ... <cmd-n>
is_callable() {
  local cmd
  for cmd in "$@"; do
    command -v "${cmd}" >/dev/null || return 1
  done
}

# Usage: take <dir>
take() {
  dir="${1}"
  if [ -n "${dir}" ]; then
    mkdir -p "${1}" && builtin cd "${1}" || return 1
  fi
}

# Usage: backupthis <file/dir>
backupthis() {
  local item
  for item in "$@"; do
    cp -riv "${item}" "${item}"-"$(date +%Y%m%d%H%M)".backup
  done
}
