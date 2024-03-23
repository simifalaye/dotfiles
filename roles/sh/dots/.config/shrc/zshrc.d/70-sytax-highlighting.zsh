#
# NOTE: This module should be loaded after all ZLE widgets have been defined.
# Namely, after the 'input' module.
#

#-
#  Plugin: zsh-syntax-highlighting
#-

# Abort if requirements are not met
(( $+functions[zcompile-many] )) || return 1
[[ -o interactive ]] || return 1

# Load plugin
plugin_dir=${ZPLUGDIR}/F-Sy-H
if [[ ! -e ${plugin_dir} ]]; then
  git clone --depth=1 https://github.com/z-shell/F-Sy-H.git ${plugin_dir}
  zcompile-many ${plugin_dir}/{functions/fast*,functions/.fast*,**/*.ch,**/*.zsh}
fi
source ${plugin_dir}/F-Sy-H.plugin.zsh
