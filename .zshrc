# Zsh always executes zshenv. Then, depending on the case:
# - run as a login shell, it executes zprofile;
# - run as an interactive, it executes zshrc;
# - run as a login shell, it executes zlogin.
#
# At the end of a login session, it executes zlogout, but in reverse order, the
# user-specific file first, then the system-wide one, constituting a chiasmus
# with the zlogin files.

# Source global definitions
test -r ~/.shell-env && . ~/.shell-env
test -r ~/.shell-aliases && . ~/.shell-aliases
test -r ~/.shell-common && . ~/.shell-common

setopt appendhistory
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

# EMACS mode
bindkey -e
# TODO: This might be neat: http://unix.stackexchange.com/a/47425
# TODO: Nice list of bindings: http://zshwiki.org/home/zle/bindkeys
# Make CTRL+Arrow skip words
# rxvt
bindkey "^[Od" backward-word
bindkey "^[Oc" forward-word
# xterm
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
# gnome-terminal
bindkey "^[OD" backward-word
bindkey "^[OC" forward-word

bindkey "^U" backward-kill-line
bindkey "^Q" push-line-or-edit

# Ignore interactive commands from history
export HISTORY_IGNORE="(ls|bg|fg|pwd|exit|cd ..)"

fpath=(/usr/share/zsh/vendor-completions/ $fpath)

# ###################################################################
# Plugin config: ZGEN
# ###################################################################
# load zgen
if [ ! -f "${HOME}/.zgen/zgen.zsh" ]; then
    git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
fi
source "${HOME}/.zgen/zgen.zsh"

# if the init scipt doesn't exist
if ! zgen saved; then
    echo "Creating a zgen save"

    # zgen oh-my-zsh

    # plugins
    # zgen oh-my-zsh plugins/git
    # zgen oh-my-zsh plugins/sudo
    zgen load MichaelAquilina/zsh-you-should-use
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load zsh-users/zsh-autosuggestions

    # bulk load
    zgen loadall <<EOPLUGINS
        zsh-users/zsh-history-substring-search
EOPLUGINS
    # ^ can't indent this EOPLUGINS

    # completions
    zgen load zsh-users/zsh-completions src

    # theme
    zgen load denysdovhan/spaceship-prompt spaceship

    # save all to init script
    zgen save
fi

# Accept suggestion with end
bindkey '^[[F' autosuggest-accept
# bindkey -r '^ ' autosuggest-accept

# ###################################################################
# Functions
# ###################################################################
# Command: mkcd - makes a directory and cd's into it
function mkcd {
    command mkdir $1 && cd $1
}
# Command: hdi - runs howdoi with common settings
function hdi() {
    command howdoi $* -c -n 5;
};
# Command: Push dotfiles to github
function dotfiles() {
    command yadm commit -a -m "Latest file updates"
    command yadm push
}

# Adds the fzf bash config to the shell
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
