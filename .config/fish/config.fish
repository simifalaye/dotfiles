# Genral Config
# ===============
source ~/.config/fish/env.fish
set -U fish_user_paths /usr/local/sbin /usr/local/bin /usr/bin /bin
# Fish should not add things to clipboard when killing
# See https://github.com/fish-shell/fish-shell/issues/772
set FISH_CLIPBOARD_CMD "cat"

# Abbreviations
# ===============

# Run common commands with default options
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep="grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Common task abbreviations
abbr -a clr    clear
abbr -a o      'xdg-open'
abbr -a reload 'source ~/.config/fish/config.fish'
abbr -a run    'bash -c \''

# Editor
if command -v nvim >/dev/null
    abbr -a e       'nvim'
    abbr -a vimdiff 'nvim -d'
    abbr -a vim     'echo "Use e!!!"'
end

# Tmux
if command -v tmux >/dev/null
    abbr -a tmux  'tmux -2'
    abbr -a twork "tmux new-session -A -s 'Work'"
    abbr -a ta    'tmux attach -t'
    abbr -a tl    'tmux ls'
end

# Bat abbreviations (a better cat)
if command -v bat >/dev/null
    abbr -a cat "bat -p"
end

# Git
if command -v git >/dev/null and
    abbr -a gbclean "git branch | grep -v '^*' | xargs git branch -D"
end

# Navigation
abbr -a home  'cd ~'
abbr -a dev   'cd ~/dev'
abbr -a dl    'cd ~/Downloads'
abbr -a docs  'cd ~/Documents'
abbr -a works 'cd ~/Workspaces'
abbr -a pics  'cd ~/Pictures'
abbr -a vids  'cd ~/Videos'
abbr -a ..    'cd ..'
abbr -a ...   'cd ../..'
abbr -a ....  'cd ../../..'

# Shell programs
# ================

# Base16 Shell if status --is-interactive
if status --is-interactive
    set BASE16_SHELL "$HOME/.config/base16-shell/"
    source "$BASE16_SHELL/profile_helper.fish"
end
# Fzf
if test -e $HOME/.config/.fzf/shell/key-bindings.fish
    source $HOME/.config/.fzf/shell/key-bindings.fish
end
# Autojump
if test -f /usr/share/autojump/autojump.fish;
    source /usr/share/autojump/autojump.fish;
end

# Fish Functions
# ===============

# Get rid of fish greeting
function fish_greeting
end

# Set the prompt function
# Fish git prompt
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate ''
set __fish_git_prompt_showupstream 'none'
set -g fish_prompt_pwd_dir_length 3
function fish_prompt
    # Save status of last cmd
    set -l last_status $status
    # Date time
    set_color brblack
    echo -n "["(date "+%H:%M")"] "
    # Hostname
    if not test $last_status -eq 0
        set_color $fish_color_error
    else
        set_color blue
    end
    echo -n (hostname)
    # Current dir
    if [ $PWD != $HOME ]
        set_color brblack
        echo -n ':'
        set_color yellow
        echo -n (basename $PWD)
    end
    # Git
    set_color green
    printf '%s ' (__fish_git_prompt)
    # Jobs
    set numjobs (jobs -p | wc -l)
    set_color red
    if [ $numjobs -gt 0 ]
        echo -n "*$numjobs "
    end
    # Prompt
    set_color red
    echo -n '| '
    # End
    set_color normal
end

function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert
    # Without an argument, fish_vi_key_bindings will default to
    # resetting all bindings.
    # The argument specifies the initial mode (insert, "default" or visual).
    fish_vi_key_bindings insert
    # Esc with jk
    bind -M insert -m default jk backward-char force-repaint
    # Fzf keybinds
    if functions -q fzf_key_bindings
        fzf_key_bindings
    end
end

function fish_mode_prompt --description 'Displays the current mode'
    # Do nothing if not in vi mode
    if test "$fish_key_bindings" = "fish_vi_key_bindings"
        switch $fish_bind_mode
            case default
                set_color --bold red
                echo "! "
            case insert
                set_color --bold green
                echo "⋊>"
            case replace-one
                set_color --bold green
                echo "R "
            case visual
                set_color --bold brmagenta
                echo "V "
        end
        set_color normal
        printf " "
    end
end

