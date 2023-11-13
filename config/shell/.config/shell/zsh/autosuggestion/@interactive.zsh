# shellcheck shell=zsh

# NOTE: Similarly to syntax-highlighting, this module wraps ZLE widgets and
# should be loaded after all widgets have been defined.
# For best results, syntax-highlighting should be loaded before so that
# highlighting is updated when the plugin updates the editor buffer.

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

# Load plugin
plugin_dir=${ZPLUGDIR}/zsh-autosuggestions
if [[ ! -e ${plugin_dir} ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ${plugin_dir}
  zcompile-many ${plugin_dir}/{zsh-autosuggestions.zsh,src/**/*.zsh}
fi
source ${plugin_dir}/zsh-autosuggestions.zsh

# Setup zle keybinds
bindkey "${keys[Ctrl]} " autosuggest-accept
