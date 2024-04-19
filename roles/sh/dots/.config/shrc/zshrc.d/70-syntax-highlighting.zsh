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
plugin_dir=${ZPLUGDIR}/zsh-syntax-highlighting
if [[ ! -e ${plugin_dir} ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${plugin_dir}
  zcompile-many ~/zsh-syntax-highlighting/{zsh-syntax-highlighting.zsh,highlighters/*/*.zsh}
fi
source ${plugin_dir}/zsh-syntax-highlighting.zsh
