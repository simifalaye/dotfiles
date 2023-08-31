# shellcheck shell=zsh

# NOTE: Similarly to syntax-highlighting, this module wraps ZLE widgets and
# should be loaded after all widgets have been defined.
# For best results, syntax-highlighting should be loaded before so that
# highlighting is updated when the plugin updates the editor buffer.
# NOTE: Must be loaded after $keys array is defined using terminfo

# Load plugin
plugin_dir=${ZPLUGDIR}/zsh-history-substring-search
if [[ ! -e ${plugin_dir} ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search.git ${plugin_dir}
  zcompile-many ${plugin_dir}/zsh-history-substring-search.plugin.zsh
fi
source ${plugin_dir}/zsh-history-substring-search.plugin.zsh

# Half case-sensitive: lower matches upper, upper does not match lower.
HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS=l

# Rebind up/down keys to use the loaded widgets.
bindkey "$keys[Up]" history-substring-search-up
bindkey "$keys[Down]" history-substring-search-down
bindkey "$keys[Ctrl]p" history-substring-search-up
bindkey "$keys[Ctrl]n" history-substring-search-down
