# Source global definitions
test -r $SHELL_CONF_HOME/shell-aliases && . $SHELL_CONF_HOME/shell-aliases

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

# Config
# --------
_load $ZDOTDIR/config.zsh
_load $ZDOTDIR/keybinds.zsh
_load $ZDOTDIR/prompt.zsh

# Shell Programs
# ----------------
# Colors: Base16 Shell
_load_repo chriskempson/base16-shell $HOME/.config/base16-shell
[ -n "$PS1" ] && eval "$("$HOME/.config/base16-shell/profile_helper.sh")"

# Fzf
[ -f ${XDG_CONFIG_HOME:-$HOME}/fzf/fzf.zsh ]&& {
    source ${XDG_CONFIG_HOME}/fzf/fzf.zsh
    _is_callable "fd" && { # Use fd-find instead of built in
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    }
}

# Pipe helpers
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L="| less"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"
