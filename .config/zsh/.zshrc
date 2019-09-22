# Source global definitions
test -r ~/.shell-aliases && . ~/.shell-aliases
test -r ~/.shell-env && . ~/.shell-env

########## Plugin config: Zgen #########
# load zgen
_load_repo tarjoilija/zgen $ZGEN_DIR zgen.zsh
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen load zsh-users/zsh-autosuggestions
    zgen load zdharma/fast-syntax-highlighting
    zgen load zsh-users/zsh-history-substring-search
    zgen load zsh-users/zsh-completions src
    zgen load marzocchi/zsh-notify

    # save all to init script
    zgen save
fi

# Load additional config
_load $ZDOTDIR/config.zsh
_load $ZDOTDIR/prompt.zsh
_load $ZDOTDIR/keybinds.zsh

########## END #########

# Adds the fzf bash config to the shell
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
