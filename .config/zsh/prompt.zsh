#!/bin/zsh
# Fork of: https://github.com/jackharrisonsherlock/common

# Prompt
# COMMON_PROMPT_SYMBOL="❯"
# COMMON_VIMODE_FORMAT=""
COMMON_PROMPT_SYMBOL="!"
COMMON_VIMODE="1"

# Colors
COMMON_COLORS_HOST_ME=green
COMMON_COLORS_HOST_AWS_VAULT=yellow
COMMON_COLORS_CURRENT_DIR=blue
COMMON_COLORS_RETURN_STATUS_TRUE=yellow
COMMON_COLORS_RETURN_STATUS_FALSE=red
COMMON_COLORS_GIT_STATUS_DEFAULT=green
COMMON_COLORS_GIT_STATUS_STAGED=red
COMMON_COLORS_GIT_STATUS_UNSTAGED=yellow
COMMON_COLORS_GIT_PROMPT_SHA=green
COMMON_COLORS_BG_JOBS=yellow

# Prompt Items
# =============

# Host
common_host() {
    if [[ -n $SSH_CONNECTION ]]; then
        me="%n@%m"
    elif [[ $LOGNAME != $USER ]]; then
        me="%n"
    fi
    if [[ -n $me ]]; then
        echo "%{$fg[$COMMON_COLORS_HOST_ME]%}$me%{$reset_color%}:"
    fi
    if [[ $AWS_VAULT ]]; then
        echo "%{$fg[$COMMON_COLORS_HOST_AWS_VAULT]%}$AWS_VAULT%{$reset_color%} "
    fi
}

# Current directory
common_current_dir() {
    echo -n "%{$fg[$COMMON_COLORS_CURRENT_DIR]%}%c "
}

# Prompt symbol
common_return_status() {
    echo -n "%(?.%F{$COMMON_COLORS_RETURN_STATUS_TRUE}.%F{$COMMON_COLORS_RETURN_STATUS_FALSE})$COMMON_PROMPT_SYMBOL%f "
}

# Git status
common_git_status() {
    vcs_info
    local message=""
    local message_color="%F{$COMMON_COLORS_GIT_STATUS_DEFAULT}"

    # check if we're in a git repo
    command git rev-parse --is-inside-work-tree &>/dev/null || return

    # check if it's dirty
    local umode="-uno" #|| local umode="-unormal"
    command test -n "$(git status --porcelain --ignore-submodules ${umode} 2>/dev/null | head -100)"
    if [[ $? == 0 ]]; then
        message_color="%F{$COMMON_COLORS_GIT_STATUS_STAGED}"
    elif [[ -n ${unstaged} ]]; then
        message_color="%F{$COMMON_COLORS_GIT_STATUS_UNSTAGED}"
    fi

    local branch=$vcs_info_msg_0_
    message+="${message_color}${branch}%f"

    echo -n "${message}"
}

# Background Jobs
common_bg_jobs() {
    bg_status="%{$fg[$COMMON_COLORS_BG_JOBS]%}%(1j.↓%j .)"
    echo -n $bg_status
}

# Vi mode
common_vi_mode() {
    local vimode_default="%F{red}[NORMAL]%f"
    #If COMMON_VIMODE is set, set to either COMMON_VIMODE_FORMAT or a default value
    local vimode_indicator="${COMMON_VIMODE:+${COMMON_VIMODE_FORMAT:-${vimode_default}}}"
    prompt_vimode="${${KEYMAP/vicmd/$vimode_indicator}/(main|viins)/}"

    echo -n "${prompt_vimode}"
}

# Prompt Bootstrap
# ================

function prompt_common_precmd()
{
    keymap=$1
    [[ $keymap != 1 ]] && print ""  # newline before prompt

    # Left Prompt
    PROMPT='$(common_host)$(common_current_dir)$(common_bg_jobs)$(common_return_status)'
    # Right Prompt
    RPROMPT='$(common_vi_mode)$(common_git_status)'
}

function zle-keymap-select
{
    prompt_common_precmd 1
    zle reset-prompt
}

function common_setup()
{
    prompt_opts=(cr percent sp subst)

    autoload -Uz add-zsh-hook
    autoload -Uz vcs_info

    zle -N zle-keymap-select

    add-zsh-hook precmd prompt_common_precmd

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:git*' formats ' %b'
    zstyle ':vcs_info:git*' actionformats ' %b|%a'

    return 0
}

# =====
# Main
# =====

common_setup "$@"
