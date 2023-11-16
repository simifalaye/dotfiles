# shellcheck shell=zsh

#-
#  Core module: Git
#-

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
zstyle ':zim:git' aliases-prefix 'g'

#-
#  Core module: Input
#-

# Append \`../\` to your input for each \`.\` you type after an initial \`..\`
zstyle ':zim:input' double-dot-expand yes

#-
#  Core module: Completion
#-

# Move dump files to zcache directory
zstyle ':zim:completion' dumpfile "${ZCACHEDIR}/zcompdump"
zstyle ':completion::complete:*' cache-path "${ZCACHEDIR}/zcompcache"

#-
#  zsh-history-substring-search module
#-

# Half case-sensitive: lower matches upper, upper does not match lower.
HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS=l

#-
#  zsh-autosuggest module
#-

# Disable highlighting for terminals with 8-color or less.
(( $terminfo[colors] <= 8 )) && ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=''

# Find suggestions from the history only.
ZSH_AUTOSUGGEST_STRATEGY=(history)
# Disable suggestions for large buffers.
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Do not rebind widgets on each precmd for performance.
# Use `_zsh_autosuggest_bind_widgets` to rebind if widgets are added or wrapped
# after the plugin has been loaded.
ZSH_AUTOSUGGEST_MANUAL_REBIND=y
# Fetch suggestions asynchronously.
ZSH_AUTOSUGGEST_USE_ASYNC=y

# Widgets in this array will clear the suggestion when invoked.
ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(
  accept-line
  accept-and-hold
  accept-and-infer-next-history
  accept-line-and-down-history
  history-search-forward
  history-search-backward
  history-beginning-search-forward
  history-beginning-search-backward
  history-substring-search-up
  history-substring-search-down
  up-line-or-beginning-search
  down-line-or-beginning-search
  up-line-or-history
  down-line-or-history
  up-history
  down-history
  _most_recent_file
  _history-complete-older
  _history-complete-newer
  run-help
)

# Widgets in this array will not trigger any custom behavior.
ZSH_AUTOSUGGEST_IGNORE_WIDGETS=(
  orig-\*
  zle-\*
  beep
  set-local-history
  which-command
  # BUG: Does not work: If bound the widget inserts the widget name (.run-help)
  # in the command line instead of the function-name.  So for now the widget is
  # ignored and the suggestion not cleared...
  run-help
  # BUG: This allows yank-pop to work properly but prevents updating the
  # suggestion after a yank, leaving the previous suggestion displayed.
  # https://github.com/zsh-users/zsh-autosuggestions/issues/526
  # Does not work even with this related patch:
  # https://github.com/zsh-users/zsh-autosuggestions/issues/363
  yank
  yank-pop
)

#-
#  Zim setup
#-

# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
[ -f ${ZIM_CONFIG_FILE} ] && conf=${ZIM_CONFIG_FILE} || conf=${ZDOTDIR:-${HOME}}/.zimrc
if [[ ! ${ZIM_HOME}/init.zsh -nt ${conf} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

# Initialize modules.
source ${ZIM_HOME}/init.zsh
