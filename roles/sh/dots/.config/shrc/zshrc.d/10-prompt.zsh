#-
#  Plugin: Pure prompt
#-

# Abort if requirements are not met.
(( $+functions[zcompile-many] )) || return 1

# Load plugin
plugin_dir=${ZPLUGDIR}/pure
if [[ ! -e ${plugin_dir} ]]; then
  git clone --depth=1 https://github.com/sindresorhus/pure.git ${plugin_dir}
  zcompile-many ${plugin_dir}/{async.zsh,pure.zsh}
fi
fpath+=(${plugin_dir})
autoload -U promptinit; promptinit
prompt pure
