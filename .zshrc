# Zsh always executes zshenv. Then, depending on the case:
# - run as a login shell, it executes zprofile;
# - run as an interactive, it executes zshrc;
# - run as a login shell, it executes zlogin.
#
# At the end of a login session, it executes zlogout, but in reverse order, the
# user-specific file first, then the system-wide one, constituting a chiasmus
# with the zlogin files.

# Source global definitions
test -r ~/.shell-env && . ~/.shell-env || . ~/.config/.shell-env
test -r ~/.shell-aliases && . ~/.shell-aliases
test -r ~/.shell-common && . ~/.shell-common

setopt noflowcontrol # Disable ctrl s for flow control
setopt appendhistory
setopt incappendhistory
setopt autocd
setopt correct_all
setopt extendedglob
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt interactive_comments
setopt pushd_ignore_dups
setopt promptsubst
unsetopt correct_all # Remove corrections

# Ignore interactive commands from history
export HISTORY_IGNORE="(ls|bg|fg|pwd|exit|cd ..)"
# Set vendor completions path
fpath=(/usr/share/zsh/vendor-completions/ $fpath)

# ###################################################################
# Keybindings
# ###################################################################
# EMACS mode
bindkey -e
# TODO: This might be neat: http://unix.stackexchange.com/a/47425
# TODO: Nice list of bindings: http://zshwiki.org/home/zle/bindkeys
# Arrow keys right and left
bindkey "^[OD" backward-char
bindkey "^[OC" forward-char
# Make CTRL+Arrow skip words
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
# Line keys
bindkey "^U" backward-kill-line
bindkey "^Q" push-line-or-edit

# ###################################################################
# Plugin config: Zgen
# ###################################################################
if [ ! -f "${HOME}/.zgen/zgen.zsh" ]; then
    git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen" ||
    {
        echo "Failed to get zgen plugin manager."
        exit 1
    }
fi

# load zgen
source "${HOME}/.zgen/zgen.zsh"
if ! zgen saved; then
    echo "Creating a zgen save"

    # bulk load
    zgen loadall <<EOPLUGINS
        zsh-users/zsh-autosuggestions
        zdharma/fast-syntax-highlighting
        zsh-users/zsh-history-substring-search
EOPLUGINS
    # ^ can't indent this EOPLUGINS

    # completions
    zgen load zsh-users/zsh-completions src

    # theme
    zgen load mafredri/zsh-async
    zgen load marszall87/lambda-pure

    # save all to init script
    zgen save
fi

# Accept suggestion with end
bindkey '^[[F' autosuggest-accept

# Use up and down of history substring search
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

# Lambda pure prompt settings
PURE_NODE_ENABLED=0

##
## END (Must be at the bottom of config)
##

# Adds the fzf bash config to the shell
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
