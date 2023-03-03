# shellcheck disable=SC2148
source "${HOME}/.config/shell/posix/interactive.sh"

#-
#  Options
#-

# Input/output
setopt no_flow_control # Disable control flow (^S/^Q) even for non-interactive shells.
setopt interactive_comments # Allow comments starting with `#` in the interactive shell.
setopt no_clobber # Disallow `>` to overwrite existing files. Use `>|` or `>!` instead.

# CD
setopt auto_cd # pERFORM cd to a directory if the typed command is invalid, but is a directory.
setopt auto_pushd # mAKE cd push the old directory to the directory stack.
autoload -Uz is-at-least && if is-at-least 5.8; then
    setopt cd_silent # dON'T print the working directory after a cd.
fi
setopt pushd_ignore_dups # Don't push multiple copies of the same directory to the stack.
setopt pushd_silent # dOn't print the directory stack after pushd or popd.
setopt pushd_to_home # have pushd without arguments act like `pushd ${HOME}`.
setopt extended_glob # Treat `#`, `~`, and `^` as patterns for filename globbing.

# History
HISTFILE="${ZCACHEDIR}/zhistory"
HISTSIZE=20000
SAVEHIST=10000
setopt append_history           # allow multiple sessions to append to one history
setopt bang_hist                # treat ! special during command expansion
setopt extended_history         # Write history in :start:elasped;command format
setopt hist_expire_dups_first   # expire duplicates first when trimming history
setopt hist_find_no_dups        # When searching history, don't repeat
setopt hist_ignore_dups         # ignore duplicate entries of previous events
setopt hist_ignore_space        # prefix command with a space to skip it's recording
setopt hist_reduce_blanks       # Remove extra blanks from each command added to history
setopt hist_verify              # Don't execute immediately upon history expansion
setopt inc_append_history       # Write to history file immediately, not when shell quits
setopt share_history            # Share history among all sessions

# Job Control
setopt LONG_LIST_JOBS # List jobs in verbose format by default.
setopt NO_BG_NICE # Prevent background jobs being given a lower priority.
setopt NO_CHECK_JOBS # Prevent status report of jobs on shell exit.
setopt NO_HUP # Prevent SIGHUP to jobs on shell exit.

#-
#  Aliases
#-

alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L="| less"
alias -g M="| most"
alias -g HP='--help'
alias -g VR="--version"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"

#-
#  Plugins (znap)
#-

# Download Znap, if it's not there yet.
if [ ! -f ${ZDATADIR}/zsh-snap/znap.zsh ]; then
    load_repo marlonrichert/zsh-snap.git ${ZDATADIR}/zsh-snap
fi

# Configure znap
zstyle ':znap:*:<glob pattern>' git-maintenance off

# Load znap
if source ${ZDATADIR}/zsh-snap/znap.zsh; then
    # Prompt
    # ------
    # `znap prompt` makes your prompt visible in just 15-40ms!
    znap prompt sindresorhus/pure

    # Completions for common apps
    # ---------------------------
    zstyle ':zim:completion' dumpfile "${ZCACHEDIR}/zcompdump"
    zstyle ':completion::complete:*' cache-path "${ZCACHEDIR}/zcompcache"
    znap source zsh-users/zsh-completions

    # Syntax highlighting in the cmdline
    # ----------------------------------
    znap source zdharma/fast-syntax-highlighting

    # Search history by substring
    # ---------------------------
    export HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS=l
    znap source zsh-users/zsh-history-substring-search

    # Suggests commands as you type based on history and completions
    # --------------------------------------------------------------
    # Disable automatic widget re-binding on each precmd. This can be set when
    # zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
    export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
    # Find suggestions from the history only
    export ZSH_AUTOSUGGEST_STRATEGY=(history)
    # Disable suggestions for large buffers
    export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
    znap source zsh-users/zsh-autosuggestions

    # Reminder for aliases
    # --------------------
    export YSU_MODE=ALL
    znap source MichaelAquilina/zsh-you-should-use

    # Toggle prefix on command (sudo, noglob...)
    # ------------------------------------------
    znap source xPMo/zsh-toggle-command-prefix
fi

#-
#  ZLE
#-

if [[ $TERM != 'dumb' ]]; then
    # Set editor default keymap to emacs (`-e`) or vi (`-v`)
    bindkey -e

    # The terminal must be in application mode when ZLE is active for $terminfo
    # values to be valid.
    zmodload zsh/terminfo

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

    # Toggle app in bg and fg
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

    # Use human-friendly identifiers.
    typeset -gA keys
    keys=(
        'Ctrl'             '^'
        'Alt'              '\e'
        'Tab'              '\t'
        # defaults with konsole
        'Backspace'        "$terminfo[kbs]"
        'ControlBackspace' '^H'
        'Enter'            "$terminfo[cr]"
        'ShiftEnter'       "$terminfo[kent]"
        'ShiftPageUp'      "$terminfo[kPRV]"
        'ShiftPageDown'    "$terminfo[kNXT]"
        'ScrollUp'         "$terminfo[kri]"
        'ScrollDown'       "$terminfo[kind]"
        # terminfo(5)
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
    )

    # Toggle fg
    bindkey "${keys[Ctrl]}z" fancy-ctrl-z
    # Expandpace.
    bindkey ' ' magic-space
    # zsh-autosuggestions
    bindkey "${keys[Ctrl]};" forward-word
    bindkey "${keys[Ctrl]}'" end-of-line
    # zsh-history-substring-search
    bindkey "${keys[Up]}" history-substring-search-up
    bindkey "${keys[Ctrl]}p" history-substring-search-up
    bindkey "${keys[Down]}" history-substring-search-down
    bindkey "${keys[Ctrl]}n" history-substring-search-down
    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down
fi

#-
#  Applications
#-

# Base16-shell
# ------------
BASE16_SHELL="${XDG_CONFIG_HOME}/base16-shell"
load_repo chriskempson/base16-shell "${BASE16_SHELL}"
# Enable to color profile helper
if [ -n "$PS1" ]; then
    [ -s "${BASE16_SHELL}/profile_helper.sh" ] &&
        eval "$("${BASE16_SHELL}/profile_helper.sh")"
fi

# Fzf
# ---
if is_callable fzf; then
    # Source fzf keybinds & completion
    test -f /usr/share/doc/fzf/examples/key-bindings.zsh && \
        source /usr/share/doc/fzf/examples/key-bindings.zsh
    test -f usr/share/doc/fzf/examples/completion.zsh && \
        source usr/share/doc/fzf/examples/completion.zsh
fi

# Ripgrep
# -------
if is_callable rg; then
    # Path to configuration file.
    export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/config"

    # Default rg commands for integration with fzf.
    FZF_RG_COMMAND='noglob rg --files-with-matches --no-messages'
    FZF_RG_PREVIEW='noglob rg --pretty --context=10 2>/dev/null'

    # Search file contents for the given pattern and preview matches.
    # Selected entries are opened with the default opener.
    #
    # Usage: search <pattern> [rg-options...]
    search() {
        [[ ! $1 || $1 == -* ]] && echo "fs: missing rg pattern" && return 1
        local pat="$1" && shift

        selected=$( \
            FZF_HEIGHT=${FZF_HEIGHT:-90%} \
            FZF_DEFAULT_COMMAND="$FZF_RG_COMMAND $* '$pat'" \
            fzf \
            --multi \
            --preview "$FZF_RG_PREVIEW $* '$pat' {}" \
            --preview-window=wrap
        )
        # Open selected files
        # shellcheck disable=SC2086
        ${EDITOR} ${selected}
    }

    # Search files interactively and preview matches.
    # Selected entries are opened with the default opener.
    # NOTE: The optional directory MUST be given as first argument,
    # otherwise the behavior is undefined.
    #
    # Usage: search-interactive [dir] [rg-options...]
    search-interactive() {
        local dir
        [[ $1 && $1 != -* ]] && dir=$1 && shift

        selected=$( \
            FZF_HEIGHT=${FZF_HEIGHT:-90%} \
            FZF_DEFAULT_COMMAND="rg --files $* $dir" \
            fzf \
            --multi \
            --phony \
            --bind "change:reload:$FZF_RG_COMMAND {q} $* $dir || true" \
            --preview "$FZF_RG_PREVIEW {q} {} $*" \
            --preview-window=wrap \
            | cut -d":" -f1,2
        )
        # Open selected files
        # shellcheck disable=SC2086
        ${EDITOR} ${selected}
    }

    # Usability aliases.
    alias fs='search'
    alias ff='search-interactive'
fi

# Tmux
# ----
if is_callable tmux; then
    # Convenience aliases
    # shellcheck disable=SC2139
    alias tmux="tmux -2 -f '${HOME}/.config/tmux/tmux.conf'"
    alias tl="tmux ls"

    # tm [name]: Attach session or create it if it doesn't exist
    #   - If no name is provided, use fzf to select one
    tm() {
        [ -n "$TMUX" ] && change="switch-client" || change="attach-session"
        if [ "$1" ]; then
            tmux "$change" -t "$1" 2>/dev/null ||
                (tmux new-session -d -s "$1" && tmux "$change" -t "$1")
        elif is_callable fzf; then
            session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null |
                fzf --exit-0) && tmux "$change" -t "$session" || echo "No sessions found."
        fi
    }
fi

# Zoxide
# ------
if is_callable zoxide; then
    export _ZO_ECHO=1
    # Startup zoxide
    eval "$(zoxide init zsh)"
fi
