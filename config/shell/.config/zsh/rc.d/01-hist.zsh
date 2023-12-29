#
# Zsh history configurations module
#
# NOTE: Always set these first, so history is preserved, no matter what happens.
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
