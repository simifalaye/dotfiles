#
# Input configuration module
#
# NOTE: This module should be loaded after the completion module.
# This is necessary so that the `menuselect` keymap and the bindable commands
# of the completion system are available. For more information about the
# latter, see the definition of _rebind_compsys_widgets below.
#

[[ ${TERM} == dumb ]] && return

#
# Options
#

# Disable control flow (^S/^Q) even for non-interactive shells.
setopt NO_FLOW_CONTROL

#
# Keymaps
#

# Use emacs mode (Ran into several issues with vi mode)
bindkey -e

# Use human-friendly identifiers.
zmodload -F zsh/terminfo +b:echoti +p:terminfo
typeset -gA key_info
key_info=(
  Ctrl      '\C-'
  CtrlLeft  '\e[1;5D \e[5D \e\e[D \eOd \eOD'
  CtrlRight '\e[1;5C \e[5C \e\e[C \eOc \eOC'
  Escape    '\e'
  Meta      '\M-'
  Backspace '^?'
  Delete    '^[[3~'
  BackTab   "${terminfo[kcbt]}"
  Left      "${terminfo[kcub1]}"
  Down      "${terminfo[kcud1]}"
  Right     "${terminfo[kcuf1]}"
  Up        "${terminfo[kcuu1]}"
  End       "${terminfo[kend]}"
  F1        "${terminfo[kf1]}"
  F2        "${terminfo[kf2]}"
  F3        "${terminfo[kf3]}"
  F4        "${terminfo[kf4]}"
  F5        "${terminfo[kf5]}"
  F6        "${terminfo[kf6]}"
  F7        "${terminfo[kf7]}"
  F8        "${terminfo[kf8]}"
  F9        "${terminfo[kf9]}"
  F10       "${terminfo[kf10]}"
  F11       "${terminfo[kf11]}"
  F12       "${terminfo[kf12]}"
  Home      "${terminfo[khome]}"
  Insert    "${terminfo[kich1]}"
  PageDown  "${terminfo[knp]}"
  PageUp    "${terminfo[kpp]}"
)

# Add basic shell keymaps
for key in ${(s: :)key_info[CtrlLeft]}; do
  bindkey ${key} backward-word
done
for key in ${(s: :)key_info[CtrlRight]}; do
  bindkey ${key} forward-word
done
bindkey ${key_info[Backspace]} backward-delete-char
bindkey ${key_info[Delete]} delete-char
if [[ -n ${key_info[Home]} ]] bindkey ${key_info[Home]} beginning-of-line
if [[ -n ${key_info[End]} ]] bindkey ${key_info[End]} end-of-line
if [[ -n ${key_info[PageUp]} ]] bindkey ${key_info[PageUp]} up-line-or-history
if [[ -n ${key_info[PageDown]} ]] bindkey ${key_info[PageDown]} down-line-or-history
if [[ -n ${key_info[Insert]} ]] bindkey ${key_info[Insert]} overwrite-mode
if [[ -n ${key_info[Left]} ]] bindkey ${key_info[Left]} backward-char
if [[ -n ${key_info[Right]} ]] bindkey ${key_info[Right]} forward-char

# Expandpace.
bindkey ' ' magic-space

# Bind insert-last-word even in viins mode
bindkey "${key_info[Escape]}." insert-last-word
bindkey "${key_info[Escape]}_" insert-last-word

# Edit command-line in EDITOR
autoload -Uz edit-command-line && zle -N edit-command-line && \
    bindkey "${key_info[Ctrl]}x${key_info[Ctrl]}e" edit-command-line

# Bind <Shift-Tab> to go to the previous menu item.
if [[ -n ${key_info[BackTab]} ]] bindkey ${key_info[BackTab]} reverse-menu-complete

# Use smart URL pasting and escaping.
autoload -Uz bracketed-paste-url-magic && zle -N bracketed-paste bracketed-paste-url-magic
autoload -Uz url-quote-magic && zle -N self-insert url-quote-magic

# Load advanced run help
unalias run-help 2> /dev/null   # Remove the simple default.
autoload -RUz run-help          # Load a more advanced version.
# -R resolves the function immediately, so we can access the source dir.

# Load $functions_source, an associative array (a.k.a. dictionary, hash table
# or map) that maps each function to its source file.
zmodload -F zsh/parameter p:functions_source

# Lazy-load all the run-help-* helper functions from the same dir.
# autoload -Uz $functions_source[run-help]-*~*.zwc  # Exclude .zwc files.
autoload -Uz ${functions_source[run-help]-*~*.zwc(N)}

# Run help
bindkey "${key_info[Ctrl]}x${key_info[Ctrl]}h" run-help

# - On the main prompt: Push aside your current command line, so you can type a
#   new one. The old command line is re-inserted when you press Alt-G or
#   automatically on the next command line.
# - On the continuation prompt: Move all entered lines to the main prompt, so
#   you can edit the previous lines.
bindkey "${key_info[Ctrl]}x${key_info[Ctrl]}q" push-line-or-edit
bindkey "${key_info[Ctrl]}x${key_info[Ctrl]}g" get-line

# Show the next key combo's terminal code and state what it does.
bindkey "${key_info[Ctrl]}x${key_info[Ctrl]}v" describe-key-briefly

# Type a widget name and press Enter to see the keys bound to it.
# Type part of a widget name and press Enter for autocompletion.
bindkey "${key_info[Ctrl]}x${key_info[Ctrl]}w" where-is

# Edit command-line in EDITOR
autoload -Uz edit-command-line && zle -N edit-command-line && \
    bindkey "${key_info[Ctrl]}x${key_info[Ctrl]}e" edit-command-line

# Toggle process as bg and fg
fancy-ctrl-z() {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey "${key_info[Ctrl]}z" fancy-ctrl-z

# Toggle prepend "sudo" to last command
toggle-prepend-sudo() {
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
bindkey "${key_info[Escape]}${key_info[Escape]}" toggle-prepend-sudo

# Expand '..'
double-dot-expand() {
  # Expand .. at the beginning, after space, or after any of ! " & ' / ; < > |
  if [[ ${LBUFFER} == (|*[[:space:]!\"\&\'/\;\<\>|]).. ]]; then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}
zle -N double-dot-expand
bindkey . double-dot-expand
bindkey -M isearch . self-insert

# magic-enter, Output useful dir info on Enter key when the buffer is empty
_prompt_mnml_buffer-empty() {
  if [[ -z ${BUFFER} && ${CONTEXT} == start ]]; then
    clear
    # display magic enter
    print -P %F{blue}$(pwd)%f
    ls -AF
    command git status -sb 2>/dev/null
    print -Pn ${PS1}
    zle redisplay
  else
    zle accept-line
  fi
}
zle -N buffer-empty _prompt_mnml_buffer-empty
bindkey "${key_info[Ctrl]}M" buffer-empty

autoload -Uz is-at-least
if ! is-at-least 5.3; then
  # Redisplay after completing, and avoid blank prompt after <Tab><Tab><Ctrl-C>
  expand-or-complete-with-redisplay() {
    print -Pn ...
    zle expand-or-complete
    zle redisplay
  }
  zle -N expand-or-complete-with-redisplay
  bindkey "${key_info[Ctrl]}I" expand-or-complete-with-redisplay
fi

# Enables terminal application mode when the editor starts,
# so that $terminfo values are valid.
function zle-line-init {
  if (( $+terminfo[smkx] )); then
    echoti smkx
  fi
}
zle -N zle-line-init

# Disables terminal application mode when the editor exits,
# so that other applications behave normally.
function zle-line-finish {
  if (( $+terminfo[rmkx] )); then
    echoti rmkx
  fi
}
zle -N zle-line-finish
