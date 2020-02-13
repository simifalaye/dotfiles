# Setup
# ------

# Source global definitions
test -r $SHELL_CONF_HOME/shell-aliases && . $SHELL_CONF_HOME/shell-aliases
test -r $SHELL_CONF_HOME/shell-functions && . $SHELL_CONF_HOME/shell-functions

# Plugin config: Zplug
# --------------------
export ZPLUG_HOME=$XDG_CACHE_HOME/.zplug

# Load zplug and source
_load_repo zplug/zplug $ZPLUG_HOME init.zsh

zplug "rimraf/k"
zplug "zsh-users/zsh-completions", depth:1
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "urbainvaes/fzf-marks"
# Theme
zplug romkatv/powerlevel10k, as:theme, depth:1

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    else
        echo
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

# Load addtional config
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
    # Load fzf marks
    [ -f "$ZPLUG_HOME"/repos/urbainvaes/fzf-marks/fzf-marks.plugin.zsh ] && {
        source "$ZPLUG_HOME"/repos/urbainvaes/fzf-marks/fzf-marks.plugin.zsh
        FZF_MARKS_FILE="${XDG_CONFIG_HOME}/.fzf-marks"
        FZF_MARKS_JUMP="^g"
    }
}

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
