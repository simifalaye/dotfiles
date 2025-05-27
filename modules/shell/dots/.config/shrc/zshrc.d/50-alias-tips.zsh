(( $+functions[zcompile-many] )) || return 0

#
# Plugin: alias-tips
#

# Install plugin
plugin_dir=${ZPLUGDIR}/alias-tips
if [[ ! -e ${plugin_dir} ]]; then
  git clone --depth=1 https://github.com/djui/alias-tips.git ${plugin_dir}
  zcompile-many ${plugin_dir}/alias-tips.plugin.zsh
fi

# Load plugin
source ${plugin_dir}/alias-tips.plugin.zsh
