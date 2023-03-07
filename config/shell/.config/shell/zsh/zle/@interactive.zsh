# shellcheck shell=zsh

#
# ZLE(Zsh Line Editor) configuration module
#
# NOTE: This module should be loaded after the completion module.
# This is necessary so that the `menuselect` keymap and the bindable commands
# of the completion system are available. For more information about the
# latter, see the definition of _rebind_compsys_widgets below.
#

if [[ $TERM == 'dumb' ]]; then
    return 1
fi

#-
#  Character highlighting
#-

# See 'Character Highlighting' in zshzle(1).
zle_highlight=(
    isearch:underline
    region:standout
    special:standout
    suffix:bold
    paste:none # does not integrate well with syntax-highlighting
)

#-
#  ZLE Widgets
#-

# Explicitly load terminfo
zmodload zsh/terminfo

# Runs on zle start
function zle-line-init() {
    # Reset prompt
    zle reset-prompt
    zle -R
    # Enables term app mode so $terminfo values are valid
    (( ${+terminfo[smkx]} )) && echoti smkx
}
zle -N zle-line-init

# Runs on zle finish
function zle-line-finish() {
    # Disables term app mode so apps behave properly
    (( ${+terminfo[rmkx]} )) && echoti rmkx
}
zle -N zle-line-finish


# Toggle process as bg and fg
function fancy-ctrl-z {
    if [[ $#BUFFER -eq 0 ]]; then
        BUFFER="fg"
        zle accept-line
    else
        zle push-input
        zle clear-screen
    fi
}
zle -N fancy-ctrl-z

# Toggle prepend "sudo" to last command
function toggle-prepend-sudo {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == "sudo "* ]]; then
        LBUFFER="${LBUFFER#sudo }"
    elif [[ $BUFFER == "${EDITOR} "* ]]; then
        LBUFFER="${LBUFFER#$EDITOR }"
        LBUFFER="sudoedit ${LBUFFER}"
    elif [[ $BUFFER == "sudoedit "* ]]; then
        LBUFFER="${LBUFFER#sudoedit }"
        LBUFFER="${EDITOR} ${LBUFFER}"
    else
        LBUFFER="sudo ${LBUFFER}"
    fi
}
zle -N toggle-prepend-sudo

# Perform all types of shell expansions: history, alias, parameter,
# arithmetic, brace, filename.
function expand-all {
    zle _expand_alias
    zle expand-word
}
zle -N expand-all

# List key bindings.
function list-keys {
  bindkey | grep -v noop | "$PAGER"
}
zle -N list-keys

#-
#  Keymaps
#-

# Use human-friendly identifiers.
typeset -gA keys
keys=(
    'Esc'              '\e'
    'Ctrl'             '^'
    'Alt'              '^['
    'Backspace'        "$terminfo[kbs]"
    'Enter'            "$terminfo[cr]"
    'Home'             "$terminfo[khome]"
    'End'              "$terminfo[kend]"
    'Insert'           "$terminfo[kich1]"
    'Delete'           "$terminfo[kdch1]"
    'PageUp'           "$terminfo[kpp]"
    'PageDown'         "$terminfo[knp]"
    'Up'               "$terminfo[kcuu1]"
    'Left'             "$terminfo[kcub1]"
    'Down'             "$terminfo[kcud1]"
    'Right'            "$terminfo[kcuf1]"
    'BackTab'          "$terminfo[kcbt]"
    'ShiftEnter'       "$terminfo[kent]"
    'ShiftPageUp'      "$terminfo[kPRV]"
    'ShiftPageDown'    "$terminfo[kNXT]"
    'ScrollUp'         "$terminfo[kri]"
    'ScrollDown'       "$terminfo[kind]"
)

# General
# ---------

# Emacs mode
bindkey -e

# Fix basic behaviour
bindkey ${keys[Backspace]} backward-delete-char
bindkey ${keys[Delete]} delete-char
if [[ -n ${keys[Home]} ]] bindkey ${keys[Home]} beginning-of-line
if [[ -n ${keys[End]} ]] bindkey ${keys[End]} end-of-line
if [[ -n ${keys[PageUp]} ]] bindkey ${keys[PageUp]} up-line-or-history
if [[ -n ${keys[PageDown]} ]] bindkey ${keys[PageDown]} down-line-or-history
if [[ -n ${keys[Insert]} ]] bindkey ${keys[Insert]} overwrite-mode
if [[ -n ${keys[Left]} ]] bindkey ${keys[Left]} backward-char
if [[ -n ${keys[Right]} ]] bindkey ${keys[Right]} forward-char

# Expandpace.
bindkey ' ' magic-space

# <Ctrl-x><Ctrl-e> to edit command-line in EDITOR
autoload -Uz edit-command-line && zle -N edit-command-line && \
    bindkey "${keys[Ctrl]}x${keys[Ctrl]}e" edit-command-line

# Bind <Shift-Tab> to go to the previous menu item.
if [[ -n ${keys[BackTab]} ]] bindkey ${keys[BackTab]} reverse-menu-complete

# Use smart URL pasting and escaping.
autoload -Uz bracketed-paste-url-magic && zle -N bracketed-paste bracketed-paste-url-magic
autoload -Uz url-quote-magic && zle -N self-insert url-quote-magic

# Toggle process bg and fg
bindkey "${keys[Ctrl]}z" fancy-ctrl-z

# Add sudo to last command
bindkey "${keys[Ctrl]}\\" toggle-prepend-sudo

# Expand whatever is under the cursor.
bindkey "${keys[Ctrl]};" expand-all

# List key bindings.
bindkey "${keys[Ctrl]}x${keys[Ctrl]}?" list-keys
