# shellcheck shell=zsh

# NOTE: This module should be loaded after all ZLE widgets have been defined.
# In general, that means after completion and ZLE settings.

if [[ $TERM == 'dumb' ]]; then
  return 1
fi

# Load plugin
plugin_dir=${ZPLUGDIR}/zsh-syntax-highlighting
if [[ ! -e ${plugin_dir} ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${plugin_dir}
  zcompile-many ${plugin_dir}/{zsh-syntax-highlighting.zsh,highlighters/*/*.zsh}
fi
source ${plugin_dir}/zsh-syntax-highlighting.zsh
