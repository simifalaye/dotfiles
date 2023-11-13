# shellcheck shell=zsh

# NOTE: This module should be loaded after all ZLE widgets have been defined.
# In general, that means after completion and ZLE settings.

if [[ $TERM == 'dumb' ]]; then
  return 1
fi

# Load plugin
plugin_dir=${ZPLUGDIR}/F-Sy-H
if [[ ! -e ${plugin_dir} ]]; then
  git clone --depth=1 https://github.com/z-shell/F-Sy-H.git ${plugin_dir}
  zcompile-many ${plugin_dir}/{functions/fast*,functions/.fast*,**/*.ch,**/*.zsh}
fi
source ${plugin_dir}/F-Sy-H.plugin.zsh
