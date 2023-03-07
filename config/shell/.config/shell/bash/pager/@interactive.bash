# shellcheck shell=bash

if [[ $TERM == 'dumb' ]]; then
    return 1
fi

# Convenience aliases.
alias p='${PAGER}'
alias more='less'

# Set default less options.
export LESSHISTFILE="${XDG_STATE_HOME}/less/history"
export LESSKEY="${XDG_STATE_HOME}/less/key"
export LESSHISTSIZE=50
export LESS='-QRSMi -#.25 --no-histdups'
export SYSTEMD_LESS="$LESS"

# Create less dir if not created
mkdir -p "${XDG_STATE_HOME}/less"

# Set default colors for less.
export LESS_TERMCAP_mb=$'\E[01;31m'    # begins blinking
export LESS_TERMCAP_md=$'\E[01;34m'    # begins bold
export LESS_TERMCAP_me=$'\E[0m'        # ends mode
export LESS_TERMCAP_so=$'\E[00;47;30m' # begins standout-mode
export LESS_TERMCAP_se=$'\E[0m'        # ends standout-mode
export LESS_TERMCAP_us=$'\E[01;33m'    # begins underline
export LESS_TERMCAP_ue=$'\E[0m'        # ends underline

# Pager integration with bat.
if is_callable bat; then
  export BAT_PAGER='less -F'
  alias cat="bat -p"
fi
