# Setup
# ------

# Source global definitions
test -r $SHELL_CONF_HOME/shell-aliases && . $SHELL_CONF_HOME/shell-aliases
test -r $SHELL_CONF_HOME/shell-functions && . $SHELL_CONF_HOME/shell-functions

# Plugin config: Zinit
# --------------------
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
zinit light rupa/z

# Theme
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure
PURE_PROMPT_SYMBOL='➜'
PURE_PROMPT_VICMD_SYMBOL='!'

# Additional Configs
# ------------------

_load $ZDOTDIR/config.zsh
_load $ZDOTDIR/keybinds.zsh

# Load shell programs
# -------------------

# Colors: Base16 Shell
_load_repo chriskempson/base16-shell $HOME/.config/base16-shell
[ -n "$PS1" ] && eval "$("$HOME/.config/base16-shell/profile_helper.sh")"

# Fzf
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && {
    # Load fzf
    source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh
    # Use rg for default search
    _is_callable "rg" && {
        export FZF_DEFAULT_COMMAND='rg --files --hidden'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    }
}
