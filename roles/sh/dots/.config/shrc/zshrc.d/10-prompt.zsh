#-
#  Plugin: Pure prompt
#-

# Load plugin
plugin_dir=${ZPLUGDIR}/powerlevel10k
if [[ ! -e ${plugin_dir} ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${plugin_dir}
  make -C ~/powerlevel10k pkg
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source "${plugin_dir}/powerlevel10k.zsh-theme"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
