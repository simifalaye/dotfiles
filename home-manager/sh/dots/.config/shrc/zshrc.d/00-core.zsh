#
# General
#

# Autoload all module functions (Using lambda for local vars).
() {
  local func
  local skip_glob='^([_.]*|prompt_*_setup|*~)(-.N:t)'

  # Extended globbing is needed for listing autoloadable function directories.
  setopt local_options extended_glob

  for func in ${HOME}/.config/shrc/zshrc.d/functions/$~skip_glob; do
    autoload -Uz "$func"
  done
}

#
# History Options
#

# Tell zsh where to store history.
# := assigns the variable and then substitutes the expression with its value.
HISTFILE="${ZCACHEDIR}/history"

# Just in case: If the parent directory doesn't exist, create it.
[[ -d $HISTFILE:h ]] ||
  mkdir -p $HISTFILE:h

# Max number of entries to keep in history file.
SAVEHIST=$(( 100 * 1000 ))      # Use multiplication for readability.

# Max number of history entries to keep in memory.
HISTSIZE=$(( 1.2 * SAVEHIST ))  # Zsh recommended value

# Expire duplicates first when trimming history
setopt HIST_EXPIRE_DUPS_FIRST

# Use modern file-locking mechanisms, for better safety & performance.
setopt HIST_FCNTL_LOCK

# When searching history, don't repeat
setopt HIST_FIND_NO_DUPS

# Keep only the most recent copy of each duplicate entry in history.
setopt HIST_IGNORE_ALL_DUPS

# Prefix command with a space to skip it's recording
setopt HIST_IGNORE_SPACE

# Remove extra blanks from each command added to history
setopt HIST_REDUCE_BLANKS

# Don't execute immediately upon history expansion
setopt HIST_VERIFY

# Write to history file immediately, not when shell quits
setopt INC_APPEND_HISTORY

# Share history among all sessions
setopt SHARE_HISTORY

#
# CD options
#

# Perform cd to a directory if the typed command is invalid, but is a directory.
setopt AUTO_CD

# Make cd push the old directory to the directory stack.
setopt AUTO_PUSHD

autoload -Uz is-at-least && if is-at-least 5.8; then
# Don't print the working directory after a cd.
setopt CD_SILENT
fi

# Don't push multiple copies of the same directory to the stack.
setopt PUSHD_IGNORE_DUPS

# Don't print the directory stack after pushd or popd.
setopt PUSHD_SILENT

#
# Named directories
#

# Create shortcuts for your favorite directories.
# Set these early, because it affects how dirs are displayed and printed.
# `hash -d <name>=<path>` makes ~<name> a shortcut for <path>.
# You can use this ~name anywhere you would specify a dir, not just with `cd`!
hash -d zcfg="${ZDOTDIR}"
hash -d zdata="${ZDATADIR}"
hash -d zplug="${ZPLUGDIR}"
hash -d dot="${HOME}/.dotfiles"
hash -d cfg="${XDG_CONFIG_HOME}"
hash -d data="${XDG_DATA_HOME}"

#
# Aliases
#

# Global aliases
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

#
# Plugin manager
#

# Download Znap, if it's not there yet
[[ -r "${ZDATADIR}"/znap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git "${ZDATADIR}"/znap

# Configure Znap
zstyle ':znap:*' repos-dir "${ZDATADIR}"/plugins
zstyle '*:compinit' arguments -d "${ZCACHEDIR}/zcompdump"

# Load Znap
source "${ZDATADIR}"/znap/znap.zsh
