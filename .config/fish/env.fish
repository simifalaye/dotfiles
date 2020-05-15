# General Env
# =============

setenv XDG_CACHE_HOME ~/.cache
setenv XDG_CONFIG_HOME ~/.config
setenv XDG_DATA_HOME ~/.local/share
setenv XDG_BIN_HOME ~/.local/bin
setenv SHELL /usr/bin/fish
setenv SHELL_CONF_HOME ~/.config/shell
setenv TERMCMD st

# Wsl specific
if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null
    setenv IS_WSL_DEVICE true
    # IMPORTANT (for vim copy paste)
    setenv DISPLAY "localhost:0"
    # For wsl dir colors
    setenv LS_COLORS "ow=01;36;40"
    # Wsl file/folder permissions metadata
    umask 022
end


# Program Variables
# ===================

setenv VIM_HOME_DIR "$XDG_CONFIG_HOME/nvim"

setenv FZF_SOURCE_DIR "$XDG_CONFIG_HOME/.fzf"
setenv FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
setenv FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

setenv LPASS_CLIPBOARD_COMMAND "xclip -selection clipboard -in -l 3"
setenv LPASS_AGENT_TIMEOUT 0

# Editors
# =========

setenv EDITOR 'nvim'
setenv GIT_EDITOR "$EDITOR"
setenv USE_EDITOR "$EDITOR"
setenv VISUAL $EDITOR

# Paths
# =======

test -d "$HOME/bin" && setenv PATH "$HOME/bin:$PATH"
test -d "$HOME/.local/bin" && setenv PATH "$HOME/.local/bin:$PATH"

# Pager and flow
# ================

setenv PAGER less
setenv LESS "-F -X -R"
# Ignore basic commands in history
setenv HISTORY_IGNORE "(ls|bg|fg|pwd|exit|cd ..)"
# Colored man
setenv LESS_TERMCAP_mb (tput bold; tput setaf 6)
setenv LESS_TERMCAP_md (tput bold; tput setaf 6)
setenv LESS_TERMCAP_me (tput sgr0)
setenv LESS_TERMCAP_se (tput rmso; tput sgr0)
setenv LESS_TERMCAP_ue (tput rmul; tput sgr0)
setenv LESS_TERMCAP_us (tput smul; tput bold; tput setaf 4)
setenv LESS_TERMCAP_mr (tput rev)
setenv LESS_TERMCAP_mh (tput dim)
setenv LESS_TERMCAP_ZN (tput ssubm)
setenv LESS_TERMCAP_ZV (tput rsubm)
setenv LESS_TERMCAP_ZO (tput ssupm)
setenv LESS_TERMCAP_ZW (tput rsupm)
