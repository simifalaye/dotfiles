# vim: filetype=zsh

# Description
# ===========
# This file is sourced by all `zsh` shells.
# It is read after /etc/zshenv.

# Load shell common
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/interactive"

# Plugins: Zinit
# ----------------

# Setup env
typeset -A ZINIT
ZINIT_HOME=$XDG_CACHE_HOME/zsh/zinit
ZINIT[HOME_DIR]=$ZINIT_HOME
ZINIT[ZCOMPDUMP_PATH]=$XDG_CACHE_HOME/zsh/zcompdump

# Zinit load and source
_load_repo zdharma/zinit.git $ZINIT_HOME/bin zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Plugins:
# syntax highlighting & suggestions
zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" \
        zdharma/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    atload"bindkey '^[OA' history-substring-search-up; \
           bindkey '^[OB' history-substring-search-down; \
           bindkey '^[[A' history-substring-search-up; \
           bindkey '^[[B' history-substring-search-down" \
        zsh-users/zsh-history-substring-search \
    blockf \
        zsh-users/zsh-completions
# cd that learns
zinit ice wait blockf lucid; zinit light rupa/z
zinit ice wait lucid; zinit light changyuheng/fz
# Fancy ctrl-z
zinit ice wait"0b" lucid; zinit load mdumitru/fancy-ctrl-z
# Alias help
zinit light MichaelAquilina/zsh-you-should-use

# Settings
# ----------
# Aliases
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L="| less"
alias -g HP='--help'
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"

# Jobs
setopt LONG_LIST_JOBS     # List jobs in the long format by default.
setopt AUTO_RESUME        # Attempt to resume existing job before creating a new process.
setopt NOTIFY             # Report status of background jobs immediately.
unsetopt BG_NICE          # Don't run all background jobs at a lower priority.
unsetopt HUP              # Don't kill jobs on shell exit.
unsetopt CHECK_JOBS       # Don't report on jobs when shell exit.
unsetopt FLOW_CONTROL     # Disable ctrl s for flow control

# History
HISTFILE="$XDG_CACHE_HOME/zhistory"
HISTSIZE=1000                    # Max events to store in internal history.
SAVEHIST=1000                    # Max events to store in history file.
setopt BANG_HIST                 # Don't treat '!' specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt APPEND_HISTORY            # Appends history to history file on exit
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing non-existent history.

# Directories
DIRSTACKSIZE=9
setopt AUTO_CD              # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME        # Push to home directory when no argument is given.
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt MULTIOS              # Write to multiple descriptors.
setopt EXTENDED_GLOB        # Use extended globbing syntax.
unsetopt GLOB_DOTS
unsetopt AUTO_NAME_DIRS     # Don't add variable-stored paths to ~ list.

# Keybinds
# ----------
# Vi mode
bindkey -v
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M viins ' ' magic-space
# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
# General bindings
bindkey -M viins '^s' history-incremental-pattern-search-backward
bindkey -M viins '^u' backward-kill-line
bindkey -M viins '^w' backward-kill-word
bindkey -M viins '^g' push-line-or-edit
bindkey -M viins '^a' beginning-of-line
bindkey -M viins '^e' end-of-line
bindkey -M vicmd '^k' kill-line
bindkey -M vicmd 'H'  run-help

# <5.0.8 doesn't have visual map
if is-at-least 5.0.8; then
    # add vimmish text-object support to zsh
    autoload -U select-quoted; zle -N select-quoted
    for m in visual viopp; do
        for c in {a,i}{\',\",\`}; do
            bindkey -M $m $c select-quoted
        done
    done

    autoload -U select-bracketed; zle -N select-bracketed
    for m in visual viopp; do
        for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
            bindkey -M $m $c select-bracketed
        done
    done
fi

# Fix backspace
bindkey "^?" backward-delete-char
# Fix the DEL key
bindkey -M vicmd "^[[3~" delete-char
bindkey "^[[3~" delete-char
# Fix vimmish ESC
bindkey -sM vicmd '^[' '^G'
bindkey -rM viins '^X'
bindkey -M viins '^X,' _history-complete-newer \
    '^X/' _history-complete-older \
    '^X`' _bash_complete-word

# Shell Programs
# ----------------
# Prompt
_load $ZDOTDIR/prompt.zsh

# Colors: Base16 Shell
_load_repo chriskempson/base16-shell $HOME/.config/base16-shell
[ -n "$PS1" ] && eval "$("$HOME/.config/base16-shell/profile_helper.sh")"

# Fzf
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && {
    source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh
    _is_callable "fdfind" && { # Use fd-find instead of built in
        export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    }
}
