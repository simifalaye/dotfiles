#
# Plugin: alias-tips -- Reminder about aliases
#

# Abort if requirements are not met
(( $+functions[zcompile-many] )) || return 1

# Load plugin
plugin_dir=${ZPLUGDIR}/alias-tips
if [[ ! -e ${plugin_dir} ]]; then
  git clone --depth=1 https://github.com/djui/alias-tips.git ${plugin_dir}
  zcompile-many ${plugin_dir}/alias-tips.plugin.zsh
fi
source ${plugin_dir}/alias-tips.plugin.zsh
