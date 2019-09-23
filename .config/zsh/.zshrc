# Source global definitions
test -r ~/.shell-aliases && . ~/.shell-aliases

########## Plugin config: Zgen #########
# Load config and prompt
_load $ZDOTDIR/config.zsh
_load $ZDOTDIR/prompt.zsh
# Load zgen
_load_repo tarjoilija/zgen $ZGEN_DIR zgen.zsh
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen load zsh-users/zsh-autosuggestions
    zgen load zdharma/fast-syntax-highlighting
    zgen load zsh-users/zsh-history-substring-search
    zgen load zsh-users/zsh-completions src
    zgen load urbainvaes/fzf-marks
    zgen load miekg/lean # Theme

    # save all to init script
    zgen save
fi
# Load keybinds
_load $ZDOTDIR/keybinds.zsh

########## END #########

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] &&
    source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh
