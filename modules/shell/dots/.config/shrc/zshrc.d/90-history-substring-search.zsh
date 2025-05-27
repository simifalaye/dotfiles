#
# NOTE: This module wraps ZLE widgets and should be loaded after all
# widgets have been defined. Namely, after the 'input' module. For
# best results, syntax-highlighting should be loaded before so that
# highlighting is updated when the plugin updates the editor buffer.
#

(( $+functions[zcompile-many] )) || return 1
[[ -o interactive ]] || return 1

#
# Plugin: zsh-history-substring-search
#

# Half case-sensitive: lower matches upper, upper does not match lower.
HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS=l

# Install plugin
plugin_dir=${ZPLUGDIR}/zsh-history-substring-search
if [[ ! -e ${plugin_dir} ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search.git ${plugin_dir}
  zcompile-many ${plugin_dir}/zsh-history-substring-search.plugin.zsh
fi

# Load plugin
source ${plugin_dir}/zsh-history-substring-search.plugin.zsh

# Rebind up/down keys to use the loaded widgets.
if typeset -p key_info > /dev/null 2>&1; then
  bindkey "$key_info[Up]" history-substring-search-up
  bindkey "$key_info[Down]" history-substring-search-down
  bindkey "$key_info[Ctrl]p" history-substring-search-up
  bindkey "$key_info[Ctrl]n" history-substring-search-down
fi
