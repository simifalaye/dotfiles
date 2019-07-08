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

# Theme customization with powerlevel9k
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir dir_writable vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(disk_usage time status)
POWERLEVEL9K_TIME_FORMAT="%D{\uf073 %d-%h}"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=''
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=' $ '
POWERLEVEL9K_VCS_GIT_ICON='\uf09b'
POWERLEVEL9K_OS_ICON_BACKGROUND="white"
POWERLEVEL9K_OS_ICON_FOREGROUND="blue"
POWERLEVEL9K_DIR_HOME_BACKGROUND="transparent"
POWERLEVEL9K_DIR_HOME_FOREGROUND="blue"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="transparent"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="blue"
POWERLEVEL9K_VCS_CLEAN_BACKGROUND="transparent"
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="transparent"
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="transparent"
POWERLEVEL9K_VCS_CLEAN_FOREGROUND="040"
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="red"
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="yellow"
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="transparent"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="blue"

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
# Plugin config: ZPLUG
# ###################################################################
export ZPLUG_HOME=$HOME/.zplug
ZPLUG_USE_CACHE=true

if [ -f $ZPLUG_HOME/init.zsh ]; then
  source $ZPLUG_HOME/init.zsh

  zplug "plugins/extract", from:oh-my-zsh, ignore:oh-my-zsh.sh
  zplug "plugins/pip", from:oh-my-zsh, ignore:oh-my-zsh.sh
  zplug "plugins/sudo", from:oh-my-zsh, ignore:oh-my-zsh.sh
  zplug "plugins/git", from:oh-my-zsh, ignore:oh-my-zsh.sh
  zplug "plugins/web-search", from:oh-my-zsh, ignore:oh-my-zsh.sh
  zplug "plugins/autojump", from:oh-my-zsh, ignore:oh-my-zsh.sh

  zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme as:theme
  zplug "marzocchi/zsh-notify", use:"notify.plugin.zsh"
  zplug "oconnor663/zsh-sensible"

  zplug "zsh-users/zsh-completions"
  zplug "zsh-users/zsh-autosuggestions"
  zplug "zsh-users/zsh-syntax-highlighting", defer:2

  # Install plugins if there are plugins that have not been installed
  if ! zplug check --verbose; then
    printf "Install zsh plugins? [y/N]: "
    if read -q; then
      echo; zplug install
    fi
  fi
  # Use zplug clean to remove unspecified repos (plugins)

  # Then, source plugins and add commands to $PATH
  zplug load # --verbose
fi

# Accept suggestion with ctrl-space
bindkey '^ ' autosuggest-accept
bindkey '^[[F' autosuggest-accept

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
