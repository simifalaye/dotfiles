(( $+functions[zcompile-many] )) || return 0

#
# Plugin: pure
#

# Install plugin
plugin_dir=${ZPLUGDIR}/pure
if [[ ! -e ${plugin_dir} ]]; then
  git clone --depth=1 https://github.com/sindresorhus/pure.git ${plugin_dir}
  zcompile-many ${plugin_dir}/**/*.zsh
fi

# Load prompt
fpath+=(${plugin_dir})
autoload -U promptinit; promptinit
prompt pure
