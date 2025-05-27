#
# NOTE: This module wraps ZLE widgets and should be loaded after all
# widgets have been defined. Namely, after the 'input' module. For
# best results, syntax-highlighting should be loaded before so that
# highlighting is updated when the plugin updates the editor buffer.
#

[[ -o interactive ]] || return 0
(( $+functions[zcompile-many] )) || return 0

#
# Plugin: zsh-autosuggestions
#

# Disable highlighting for terminals with 8-color or less.
(( $terminfo[colors] <= 8 )) && ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=''

# Fetch suggestions asynchronously.
ZSH_AUTOSUGGEST_USE_ASYNC=y

# Install plugin
plugin_dir=${ZPLUGDIR}/zsh-autosuggestions
if [[ ! -e ${plugin_dir} ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ${plugin_dir}
  zcompile-many ${plugin_dir}/{zsh-autosuggestions.zsh,src/**/*.zsh}
fi

# Load plugin
source ${plugin_dir}/zsh-autosuggestions.zsh

# Bind C-Space to accept autosuggestion
bindkey "$key_info[Ctrl] " autosuggest-accept
