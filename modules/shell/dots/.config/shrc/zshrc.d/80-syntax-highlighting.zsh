#
# NOTE: This module should be loaded after all ZLE widgets have been defined.
# Namely, after the 'input' module.
#

#
# Plugin: fast-syntax-highlighting
#

# Abort if requirements are not met
(( $+functions[zcompile-many] )) || return 1
[[ -o interactive ]] || return 1

# Install plugin
plugin_dir=${ZPLUGDIR}/fast-syntax-highlighting
if [[ ! -e ${plugin_dir} ]]; then
  git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${plugin_dir}
  mv -- ${plugin_dir}/{'→chroma','tmp'}
  zcompile-many ${plugin_dir}/{fast*,.fast*,**/*.ch,**/*.zsh}
  mv -- ${plugin_dir}/{'tmp','→chroma'}
fi

# Load plugin
source ${plugin_dir}/fast-syntax-highlighting.plugin.zsh
