# shellcheck shell=zsh

# Load plugin
plugin_dir=${ZPLUGDIR}/zsh-you-should-use
if [[ ! -e ${plugin_dir} ]]; then
  git clone --depth=1 https://github.com/MichaelAquilina/zsh-you-should-use.git ${plugin_dir}
  zcompile-many ${plugin_dir}/you-should-use.plugin.zsh
fi
source ${plugin_dir}/you-should-use.plugin.zsh
