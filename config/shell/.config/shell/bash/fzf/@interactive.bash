# shellcheck shell=bash

if ! is_callable fzf; then
    return 1
fi

# Use fd if available
if is_callable fd; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
    export FZF_FILES_COMMAND="${FZF_DEFAULT_COMMAND} --type f"
    export FZF_DIRS_COMMAND="${FZF_DEFAULT_COMMAND} --type d"
fi

# Use tmux if inside
export FZF_TMUX=1

# Default options
export FZF_DEFAULT_OPTS='
    --height 40%
    --layout=reverse
    --cycle
    --bind change:top
    --bind alt-s:toggle-sort
    --bind alt-p:toggle-preview
    --bind alt-a:toggle-all
    --bind alt-g:top
    --bind alt-d:preview-page-down
    --bind alt-u:preview-page-up
    --bind alt-j:preview-down
    --bind alt-k:preview-up'

# Ctrl-t options
# Using highlight (http://www.andre-simon.de/doku/highlight/en/highlight.html)
export FZF_CTRL_T_OPTS="
    --preview
    '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

# Editor convinience aliases
if is_callable fzf; then
    # Edit Git: Edit git files in current dir OR yadm if not in git dir
    eg() {
        if git rev-parse --git-dir > /dev/null 2>&1; then
            git ls-files | fzf -m --preview "cat {}" | xargs "${EDITOR}"
        elif is_callable yadm; then
            yadm ls-files | fzf -m --preview "cat {}" | xargs "${EDITOR}"
        else
            echo "Not in git dir" && return
        fi
    }
fi

# Source fzf keybinds & completion
shell_name=$(ps -p $$ -o comm=)
if [[ "${shell_name}" == *"bash"* ]]; then
    include /usr/share/doc/fzf/examples/key-bindings.bash
    include /usr/share/bash-completion/completions/fzf
elif [[ "${shell_name}" == *"zsh"* ]]; then
    include /usr/share/doc/fzf/examples/key-bindings.zsh
    # TODO: causes problems with autosuggestions
    # include /usr/share/doc/fzf/examples/completion.zsh
fi
