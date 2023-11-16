# shellcheck shell=zsh

#-
#  Options
#-

# Input/output
setopt NO_FLOW_CONTROL # Disable control flow (^S/^Q) even for non-interactive shells.
setopt INTERACTIVE_COMMENTS # Allow comments starting with `#` in the interactive shell.
setopt NO_CLOBBER # Disallow `>` to overwrite existing files. Use `>|` or `>!` instead.

# CD
setopt AUTO_CD # Perform cd to a directory if the typed command is invalid, but is a directory.
setopt AUTO_PUSHD # Make cd push the old directory to the directory stack.
autoload -Uz is-at-least && if is-at-least 5.8; then
  setopt CD_SILENT # Don't print the working directory after a cd.
fi
setopt PUSHD_IGNORE_DUPS # Don't push multiple copies of the same directory to the stack.
setopt PUSHD_SILENT # Don't print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME # have pushd without arguments act like `pushd ${HOME}`.
setopt EXTENDED_GLOB # Treat `#`, `~`, and `^` as patterns for filename globbing.

# History
HISTFILE="${ZCACHEDIR}/zhistory"
HISTSIZE=20000
SAVEHIST=10000
setopt APPEND_HISTORY           # allow multiple sessions to append to one history
setopt BANG_HIST                # treat ! special during command expansion
setopt EXTENDED_HISTORY         # Write history in :start:elasped;command format
setopt HIST_EXPIRE_DUPS_FIRST   # expire duplicates first when trimming history
setopt HIST_FIND_NO_DUPS        # When searching history, don't repeat
setopt HIST_IGNORE_DUPS         # ignore duplicate entries of previous events
setopt HIST_IGNORE_SPACE        # prefix command with a space to skip it's recording
setopt HIST_REDUCE_BLANKS       # Remove extra blanks from each command added to history
setopt HIST_VERIFY              # Don't execute immediately upon history expansion
setopt INC_APPEND_HISTORY       # Write to history file immediately, not when shell quits
setopt SHARE_HISTORY            # Share history among all sessions

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
#  Hooks
#-

autoload -Uz add-zsh-hook

function -auto-ls-after-cd() {
  emulate -L zsh
  # Only in response to a user-initiated `cd`, not indirectly (eg. via another
  # function).
  if [ "$ZSH_EVAL_CONTEXT" = "toplevel:shfunc" ]; then
      ls -a
  fi
}
add-zsh-hook chpwd -auto-ls-after-cd

#-
#  Local config
#  IMPORTANT: MUST BE AT THE END TO OVERRIDE
#-

include "${HOME}/.zshrc.local" || return 0
