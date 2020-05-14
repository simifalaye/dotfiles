# Genral Config
# ===============
source ~/.config/fish/env.fish
set -U fish_user_paths /usr/local/sbin /usr/local/bin /usr/bin /bin
# Fish should not add things to clipboard when killing
# See https://github.com/fish-shell/fish-shell/issues/772
set FISH_CLIPBOARD_CMD "cat"


# Abbreviations
# ===============

# Common task abbreviations
abbr -a clr    clear
abbr -a ls     'ls --color=auto --group-directories-first'
abbr -a ll     'ls -alF'
abbr -a la     'ls -A'
abbr -a l      'ls -CF'
abbr -a grep   "grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"
abbr -a fgrep  'fgrep --color=auto'
abbr -a egrep  'egrep --color=auto'
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
    set_color brblack
    echo -n "["(date "+%H:%M")"] "
    set_color blue
    echo -n (hostname)
    if [ $PWD != $HOME ]
        set_color brblack
        echo -n ':'
        set_color yellow
        echo -n (basename $PWD)
    end
    set_color green
    printf '%s ' (__fish_git_prompt)
    set_color red
    echo -n '| '
    set_color normal
end
function fish_right_prompt -d "Write out the right prompt"
    set numjobs (jobs -p | wc -l)
    set_color red
    if [ $numjobs -eq 1 ]
        echo -n "$numjobs job"
    else if [ $numjobs -ge 2 ]
        echo -n "$numjobs jobs"
    end
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

