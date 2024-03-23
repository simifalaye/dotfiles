#
# NOTE: This module wraps ZLE widgets and should be loaded after all
# widgets have been defined. Namely, after the 'input' module. For
# best results, syntax-highlighting should be loaded before so that
# highlighting is updated when the plugin updates the editor buffer.
#

#-
#  Plugin: zsh-autosuggestions
#-

# Abort if requirements are not met
(( $+functions[zcompile-many] )) || return 1
[[ -o interactive ]] || return 1

# Disable highlighting for terminals with 8-color or less.
(( $terminfo[colors] <= 8 )) && ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=''

# Fetch suggestions asynchronously.
ZSH_AUTOSUGGEST_USE_ASYNC=y

# Load plugin
plugin_dir=${ZPLUGDIR}/zsh-autosuggestions
if [[ ! -e ${plugin_dir} ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ${plugin_dir}
  zcompile-many ${plugin_dir}/{zsh-autosuggestions.zsh,src/**/*.zsh}
fi
source ${plugin_dir}/zsh-autosuggestions.zsh
