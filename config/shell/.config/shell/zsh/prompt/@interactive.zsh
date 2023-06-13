# shellcheck shell=zsh

#-
#  Helpers
#-

__USER_LAST_CMD=""

# fastest possible way to check if repo is dirty
prompt_git_dirty() {
  command -v git >/dev/null 2>&1 || return

  # check if we're in a git repo
  [[ "$(command git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]] || return
  # check if it's dirty
  command test -n "$(git status --porcelain --ignore-submodules -unormal)" || return

  local r=$(command git rev-list --right-only --count HEAD...@'{u}' 2>/dev/null)
  local l=$(command git rev-list --left-only --count HEAD...@'{u}' 2>/dev/null)

  (( ${r:-0} > 0 )) && echo -n " %F{red}${r}-"
  (( ${l:-0} > 0 )) && echo -n " %F{green}${l}+"
  echo -n '%f'
}

# Remember each command we run.
function _record_command() {
  __USER_LAST_CMD="$2"
}

# Update vcs_info (slow) after any command that probably changed it.
function _maybe_show_vcs_info() {
  local LAST="$__USER_LAST_CMD"

  # In case user just hit enter, overwrite LAST_COMMAND, because preexec
  # won't run and it will otherwise linger.
  __USER_LAST_CMD="<unset>"

  # Check first word; via:
  # http://tim.vanwerkhoven.org/post/2012/10/28/ZSH/Bash-string-manipulation
  case "$LAST[(w)1]" in
    cd|cp|git|rm|touch|mv)
      vcs_info
      ;;
    *)
      ;;
  esac
  # Newline before prompt, except on init
  [[ -n $PROMPT_DONE ]] && print ""; PROMPT_DONE=1
}

#-
#  Hooks
#-

autoload -Uz add-zsh-hook
autoload -Uz vcs_info

add-zsh-hook preexec _record_command
add-zsh-hook precmd _maybe_show_vcs_info

#-
#  Init
#-

prompt_init() {
  # prevent the extra space in the rprompt
  [[ -n $EMACS ]] || ZLE_RPROMPT_INDENT=0
  # prevent percentage showing up
  # if output doesn't end with a newline
  export PROMPT_EOL_MARK=''

  prompt_opts=(cr subst percent)
  setopt promptsubst

  # Static prompt symbol
  PROMPT_SYMBOL="%F{red}| "
  # Updates cursor shape and prompt symbol based on vim mode
  zle-keymap-select() {
    case $KEYMAP in
      vicmd)      PROMPT_SYMBOL="%F{magenta}« " ;;
      main|viins) PROMPT_SYMBOL="%F{red}| " ;;
    esac
    zle reset-prompt
    zle -R
  }
  zle -A zle-line-init zle-keymap-select

  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' use-simple true
  zstyle ':vcs_info:*' max-exports 2
  zstyle ':vcs_info:git*' formats '%F{green}(%b)%f '
  zstyle ':vcs_info:git*' actionformats ' %b (%a)'
  # if atleast one job, print #jobs or nothing
  job='%(1j.%F{208}%j* .)%f'
  # prompt variables
  timenow="%F{8}[%D{%T}]%f "
  host='%(?.%F{blue}.%F{red})%m%f'
  dir='%F{white}:%f%F{yellow}%1d%f '

  PROMPT=$'${job}${timenow}${host}${dir}${vcs_info_msg_0_}$(prompt_git_dirty)${PROMPT_SYMBOL:-$ }'
}

prompt_init "$@"
