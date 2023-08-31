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
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=42

# Do not rebind widgets on each precmd for performance.
# Use `_zsh_autosuggest_bind_widgets` to rebind if widgets are added or wrapped
# after the plugin has been loaded.
ZSH_AUTOSUGGEST_MANUAL_REBIND=y
# Fetch suggestions asynchronously.
ZSH_AUTOSUGGEST_USE_ASYNC=y

# Load plugin
plugin_dir=${ZPLUGDIR}/zsh-autosuggestions
if [[ ! -e ${plugin_dir} ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ${plugin_dir}
  zcompile-many ${plugin_dir}/{zsh-autosuggestions.zsh,src/**/*.zsh}
fi
source ${plugin_dir}/zsh-autosuggestions.zsh
