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
test -d "$HOME/.config/.fzf/bin" && setenv PATH "$HOME/.config/.fzf/bin:$PATH"

# Pager and flow
# ================

setenv PAGER less
setenv LESS "-F -X -R"
# Ignore basic commands in history
setenv HISTORY_IGNORE "(ls|bg|fg|pwd|exit|cd ..)"
# Colored man output
# from http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
setenv LESS_TERMCAP_mb \e'[01;31m'       # begin blinking
setenv LESS_TERMCAP_md \e'[01;38;5;74m'  # begin bold
setenv LESS_TERMCAP_me \e'[0m'           # end mode
setenv LESS_TERMCAP_se \e'[0m'           # end standout-mode
setenv LESS_TERMCAP_so \e'[38;5;246m'    # begin standout-mode - info box
setenv LESS_TERMCAP_ue \e'[0m'           # end underline
setenv LESS_TERMCAP_us \e'[04;38;5;146m' # begin underline
