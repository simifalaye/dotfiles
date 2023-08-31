# shellcheck shell=sh

#-
#  Options
#-


# Fetch the current TTY.
[ ! "$TTY" ] && TTY="$(tty)"

# Disable control flow (^S/^Q).
if [ -r "${TTY:-}" ] && [ -w "${TTY:-}" ] && command -v stty >/dev/null; then
  stty -ixon
fi

# General parameters and options.
HISTFILE=        # in-memory history only
set -o noclobber # do not allow '>' to truncate existing files, use '>|'
set -o notify    # report the status of background jobs immediately

#-
#  Aliases
#-

# Elementary.
alias reload='exec $SHELL -l' # reload the current shell configuration
alias sudo='sudo '            # preserve aliases when running sudo
alias su='su -l'              # safer, simulate a real login
alias c='clear && pwd'

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
take() { [ -n "${1}" ] && mkdir -p "${1}" && builtin cd "${1}" || return; }

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

# Git
alias g='git'

# Command: Back up a file. Usage "backupthis <filename/directory>"
backupthis() { cp -riv "${1}" "${1}"-"$(date +%Y%m%d%H%M)".backup; }

#-
#  Local config
#  IMPORTANT: MUST BE AT THE END TO OVERRIDE
#-

include "${HOME}/.shellconf.local" || return 0
