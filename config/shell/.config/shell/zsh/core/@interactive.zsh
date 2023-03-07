# shellcheck shell=zsh

#-
#  Options
#-

# Input/output
setopt no_flow_control # Disable control flow (^S/^Q) even for non-interactive shells.
setopt interactive_comments # Allow comments starting with `#` in the interactive shell.
setopt no_clobber # Disallow `>` to overwrite existing files. Use `>|` or `>!` instead.

# CD
setopt auto_cd # pERFORM cd to a directory if the typed command is invalid, but is a directory.
setopt auto_pushd # mAKE cd push the old directory to the directory stack.
autoload -Uz is-at-least && if is-at-least 5.8; then
    setopt cd_silent # dON'T print the working directory after a cd.
fi
setopt pushd_ignore_dups # Don't push multiple copies of the same directory to the stack.
setopt pushd_silent # dOn't print the directory stack after pushd or popd.
setopt pushd_to_home # have pushd without arguments act like `pushd ${HOME}`.
setopt extended_glob # Treat `#`, `~`, and `^` as patterns for filename globbing.

# History
HISTFILE="${ZCACHEDIR}/zhistory"
HISTSIZE=20000
SAVEHIST=10000
setopt append_history           # allow multiple sessions to append to one history
setopt bang_hist                # treat ! special during command expansion
setopt extended_history         # Write history in :start:elasped;command format
setopt hist_expire_dups_first   # expire duplicates first when trimming history
setopt hist_find_no_dups        # When searching history, don't repeat
setopt hist_ignore_dups         # ignore duplicate entries of previous events
setopt hist_ignore_space        # prefix command with a space to skip it's recording
setopt hist_reduce_blanks       # Remove extra blanks from each command added to history
setopt hist_verify              # Don't execute immediately upon history expansion
setopt inc_append_history       # Write to history file immediately, not when shell quits
setopt share_history            # Share history among all sessions

# Job Control
setopt LONG_LIST_JOBS # List jobs in verbose format by default.
setopt NO_BG_NICE # Prevent background jobs being given a lower priority.
setopt NO_CHECK_JOBS # Prevent status report of jobs on shell exit.
setopt NO_HUP # Prevent SIGHUP to jobs on shell exit.

#-
#  Aliases
#-

alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L="| less"
alias -g M="| most"
alias -g HP='--help'
alias -g VR="--version"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"

#-
#  Local config
#  IMPORTANT: MUST BE AT THE END TO OVERRIDE
#-

include "${HOME}/.zshrc.local" || return 0
