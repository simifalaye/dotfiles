# shellcheck shell=zsh

if [[ $TERM == 'dumb' ]]; then
  return 1
fi

# Activate Powerlevel10k Instant Prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load plugin
plugin_dir=${ZPLUGDIR}/powerlevel10k
if [[ ! -e ${plugin_dir} ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${plugin_dir}
  make -C ${plugin_dir} pkg
fi
source ${plugin_dir}/powerlevel10k.zsh-theme
[[ -f ${HOME}/.p10k.zsh ]] && source ${HOME}/.p10k.zsh
