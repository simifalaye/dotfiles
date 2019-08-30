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

# Disable flow control with ctrl s (so we can ctrl+s save in vim)
setopt noflowcontrol
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

# Add colors for WSL:
# From medium.com how-to-setup-a-nice-looking-terminal-with-wsl...
[ -f ~/oss/dircolors-solarized/dircolors.256dark ] && {
    eval 'dircolors oss/dircolors-solarized/dircolors.256dark' &> /dev/null
}

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
# Plugin config: Antibody (MUST INSTALL ANTIBODY FIRST)
# ###################################################################
source ~/.zsh_plugins.sh

# Accept suggestion with end
bindkey '^[[F' autosuggest-accept

# Use up and down of history substring search
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

# Lambda pure prompt settings
PURE_NODE_ENABLED=0

# ###################################################################
# Functions
# ###################################################################
# Command: mkcd - makes a directory and cd's into it
function mkcd {
    command mkdir $1 && cd $1
}
# Command: Push dotfiles to github
function dotfiles() {
    command yadm commit -a -m "Latest file updates"
    command yadm push
}
# Command: Reload the current shell
function reloadshell() {
    echo $SHELL | grep "zsh" &> /dev/null
    if [ $? -eq 0 ]; then
        command [ -f ~/.zsh_plugins.txt ] && antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
        source ~/.zshrc
    else
        command echo "Into bash else"
    fi
}
# Command: Open directory in file explorer quietly
function open() {
    command -v jo >/dev/null 2>&1 && {
        jo $1 >/dev/null 2>&1 &
    }
}
# Command: ls when changing dirs
function cd() {
    builtin cd "$1" && ls
}

# Adds the fzf bash config to the shell
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
