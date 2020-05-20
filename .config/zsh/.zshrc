# Source global definitions
test -r $SHELL_CONF_HOME/shell-aliases && . $SHELL_CONF_HOME/shell-aliases
test -r $SHELL_CONF_HOME/shell-functions && . $SHELL_CONF_HOME/shell-functions

# Load additional config
_load $ZDOTDIR/config.zsh
_load $ZDOTDIR/prompt.zsh

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
           bindkey '^[OB' history-substring-search-down" \
        zsh-users/zsh-history-substring-search \
    blockf \
        zsh-users/zsh-completions
# cd that learns
zinit ice wait blockf lucid; zinit light rupa/z
zinit ice wait lucid; zinit light changyuheng/fz
# Fancy ctrl-z
zinit ice wait"0b" lucid; zinit load mdumitru/fancy-ctrl-z

# Shell Programs
# ----------------

# Colors: Base16 Shell
_load_repo chriskempson/base16-shell $HOME/.config/base16-shell
[ -n "$PS1" ] && eval "$("$HOME/.config/base16-shell/profile_helper.sh")"

# Fzf
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && {
    # Load fzf
    source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh
    # Use fd for default search
    _is_callable "fd" && {
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    }
}
