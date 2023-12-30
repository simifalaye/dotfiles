#
# Plugin: zsh-completions -- Extra app completion definitions
#

# Abort if requirements are not met.
(( $+functions[zcompile-many] )) || return 1

# Load plugin
plugin_dir=${ZPLUGDIR}/zsh-completions
if [[ ! -e ${plugin_dir} ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-completions.git ${plugin_dir}
  zcompile-many ${plugin_dir}/zsh-completions.plugin.zsh
fi
source ${plugin_dir}/zsh-completions.plugin.zsh
