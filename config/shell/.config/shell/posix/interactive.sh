# shellcheck disable=SC2148

#-
#  Common options
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
#  Common shell aliases
#-

# Elementary.
alias reload='exec "$SHELL"' # reload the current shell configuration
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

# Preferred apps
alias b='$BROWSER'
alias e='${VISUAL:-$EDITOR}'
alias p='${PAGER}'

# Git/yadm
alias g='git'
alias y='yadm'

#-
#  Common functions
#-

# Usage: "take .config/help"
# Create and cd into directory
take() {
    [ -n "${1}" ] && mkdir -p "${1}" && builtin cd "${1}" || return
}

# Usage: "backupthis <filename/directory>"
# Backup a file or directory
backupthis() {
    cp -riv "${1}" "${1}"-"$(date +%Y%m%d%H%M)".backup;
}

# Fetch information about a public IP address.
ipinfo()
{
    local ip_address="$1"
    while (( $# > 0 )); do
        case $1 in
            -h|--help)
                print "Usage: ip-info [-p|--public] [addr]"
                print '\nOptions:'
                print '  -p, --public  Show public IP address only'
                return
                ;;
            -p|--public)
                curl -s ipinfo.io/ip
                return
                ;;
        esac
        shift
    done

    curl -s ipinfo.io/"$ip_address"
    print
}

#-
#  Applications
#-

# Less
# ----
if is_callable less && [ "$TERM" != "dumb" ]; then
    # Set default less options.
    mkdir -p "${XDG_STATE_HOME}"/less
    export LESSHISTFILE="${XDG_STATE_HOME}/less/history"
    export LESSKEY="${XDG_STATE_HOME}/less/key"
    export LESSHISTSIZE=50
    export LESS='-QRSMi -#.25 --no-histdups'
    export SYSTEMD_LESS="${LESS}"
    # Set default colors for less.
    export LESS_TERMCAP_mb=$'\E[01;31m'    # begins blinking
    export LESS_TERMCAP_md=$'\E[01;34m'    # begins bold
    export LESS_TERMCAP_me=$'\E[0m'        # ends mode
    export LESS_TERMCAP_so=$'\E[00;47;30m' # begins standout-mode
    export LESS_TERMCAP_se=$'\E[0m'        # ends standout-mode
    export LESS_TERMCAP_us=$'\E[01;33m'    # begins underline
    export LESS_TERMCAP_ue=$'\E[0m'        # ends underline
fi

# Cht.sh
# ------
if is_callable cht.sh; then
    alias ch='cht.sh'
fi

# GPG
# ---
if is_callable gpg; then
    GPG_TTY=$(tty)
    export GPG_TTY
fi

# Bat
# ---
if is_callable bat; then
    export BAT_PAGER='less -F'
    alias cat="bat -p"
fi

# Exa
# ---
if is_callable exa; then
    export EXA_COLORS='da=1;34:gm=1;34'

    # Override ls
    alias ls='exa --group-directories-first'
    alias ll='ls -lg' # Long format, git status
    alias l='ll -a' # Long format, all files
    alias lr='ll -T' # Long format, recursive as a tree
    alias lx='ll -sextension' # Long format, sort by extension
    alias lk='ll -ssize' # Long format, largest file size last
    alias lt='ll -smodified' # Long format, newest modification time last
    alias lc='ll -schanged' # Long format, newest status change (ctime) last
fi

# Fzf
# ---
if is_callable fzf; then
    # Use fd if available
    if is_callable fd; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
        export FZF_FILES_COMMAND="${FZF_DEFAULT_COMMAND} --type f"
        export FZF_DIRS_COMMAND="${FZF_DEFAULT_COMMAND} --type d"
    fi
    # Use tmux if inside
    export FZF_TMUX=1
    # Default options
    export FZF_DEFAULT_OPTS='
        --height 40%
        --layout=reverse
        --cycle
        --bind change:top
        --bind alt-s:toggle-sort
        --bind alt-p:toggle-preview
        --bind alt-a:toggle-all
        --bind alt-g:top
        --bind alt-d:preview-page-down
        --bind alt-u:preview-page-up
        --bind alt-j:preview-down
        --bind alt-k:preview-up'
    # Ctrl-t options
    # Using highlight (http://www.andre-simon.de/doku/highlight/en/highlight.html)
    export FZF_CTRL_T_OPTS="
        --preview
        '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

    # Edit Git: Edit git files in current dir OR yadm if not in git dir
    eg() {
        if git rev-parse --git-dir > /dev/null 2>&1; then
            git ls-files | fzf -m --preview "cat {}" | xargs "${EDITOR}"
        elif is_callable yadm; then
            yadm ls-files | fzf -m --preview "cat {}" | xargs "${EDITOR}"
        else
            echo "Not in git dir" && return
        fi
    }
fi

# Trash
# -----
if is_callable trash; then
    # Convenience aliases
    alias rmm='trash'
    alias rmr='trash-restore'
    alias rml='trash-list'
fi

#-
#  Local shell config
#-

[ -r "${HOME}/.shellconf.local" ] && . "${HOME}/.shellconf.local"
