# shellcheck shell=zsh

if [[ $TERM == 'dumb' ]]; then
  return 1
fi

# # Activate Powerlevel10k Instant Prompt.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi
#
# # Load plugin
# plugin_dir=${ZPLUGDIR}/powerlevel10k
# if [[ ! -e ${plugin_dir} ]]; then
#   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${plugin_dir}
#   make -C ${plugin_dir} pkg
# fi
# source ${plugin_dir}/powerlevel10k.zsh-theme
# [[ -f ${HOME}/.p10k.zsh ]] && source ${HOME}/.p10k.zsh

#-
#  Helpers
#-

__USER_LAST_CMD=""

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
  case "$LAST[(w)1]" in
    cp|git|rm|touch|mv)
      vcs_info
      ;;
    *)
      ;;
  esac
  # Newline before prompt, except on init
  [[ -n $PROMPT_DONE ]] && print ""; PROMPT_DONE=1
}

# Update vcs_info on dir change
function _cd_show_vcs_info() {
  emulate -L zsh
  vcs_info
}

# Fastest possible way to check if repo is dirty
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

# Notify if in ssh shell or not
prompt_ssh() {
  if [[ -n "$SSH_TTY" ]]; then
    echo '%F{magenta}󰴽%f '
  else
    echo ''
  fi
}

#-
#  Hooks
#-

autoload -Uz add-zsh-hook
autoload -Uz vcs_info

add-zsh-hook preexec _record_command
add-zsh-hook precmd _maybe_show_vcs_info
add-zsh-hook chpwd _cd_show_vcs_info

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

  # Git info format
  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' use-simple true
  zstyle ':vcs_info:*' max-exports 2
  zstyle ':vcs_info:git*' formats '%F{green}(%b)%f '
  zstyle ':vcs_info:git*' actionformats ' %b (%a)'
  vcs_info # load initially

  # Prompt variables
  job='%(1j.%F{208}%j* .)%f' # if atleast one job, print #jobs or nothing
  timenow="%F{8}[%D{%R}]%f "
  host='%(?.%F{blue}.%F{red})%m%f'
  dir='%F{white}:%f%F{yellow}%1d%f '

  PROMPT=$'${job}${timenow}$(prompt_ssh)${host}${dir}${vcs_info_msg_0_}$(prompt_git_dirty)${PROMPT_SYMBOL:-$ }'
}

prompt_init "$@"
