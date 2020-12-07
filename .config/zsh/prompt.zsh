# Helpers
# ---------
# fastest possible way to check if repo is dirty
prompt_git_dirty() {
  _is_callable git || return

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

# Hooks
# -----
prompt_hook_precmd() {
  vcs_info # get git info
  # Newline before prompt, except on init
  # UNCOMMENT TO ENABLE
  # [[ -n $PROMPT_DONE ]] && print ""; PROMPT_DONE=1
}

# Initialization
# --------------
prompt_init() {
  # prevent the extra space in the rprompt
  [[ -n $EMACS ]] || ZLE_RPROMPT_INDENT=0
  # prevent percentage showing up
  # if output doesn't end with a newline
  export PROMPT_EOL_MARK=''

  # prompt_opts=(cr subst percent)
  setopt promptsubst
  autoload -Uz add-zsh-hook
  autoload -Uz vcs_info

  add-zsh-hook precmd prompt_hook_precmd
  # Updates cursor shape and prompt symbol based on vim mode
  zle-keymap-select() {
    case $KEYMAP in
      vicmd)      PROMPT_SYMBOL="%F{magenta}« " ;;
      main|viins) PROMPT_SYMBOL="%F{red}| " ;;
    esac
    zle reset-prompt
    zle -R
  }
  zle -N zle-keymap-select
  zle -A zle-keymap-select zle-line-init

  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' use-simple true
  zstyle ':vcs_info:*' max-exports 2
  zstyle ':vcs_info:git*' formats '%F{green}(%b)%f '
  zstyle ':vcs_info:git*' actionformats ' %b (%a)'
  # if atleast one job, print #jobs or nothing
  job='%(1j.%F{208}%j* .)%f'
  # prompt variables
  timenow="%F{8}[$(date "+%H:%M")]%f "
  host='%(?.%F{blue}.%F{red})%m%f'
  dir='%F{white}:%f%F{yellow}%1d%f '

  PROMPT=$'${job}${timenow}${host}${dir}${vcs_info_msg_0_}$(prompt_git_dirty)${PROMPT_SYMBOL:-$ }'
}

prompt_init "$@"
