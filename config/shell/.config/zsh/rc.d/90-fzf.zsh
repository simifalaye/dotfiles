#
# Fuzzy finder configuration module for zsh.
#
# NOTE: This module defines additional ZLE widgets and bindings and
# therefore should be loaded after the 'input' module.
#

# Abort if requirements are not met
(( $+commands[fzf] )) || return 1
[[ -o interactive ]] || return 1

#-
#  Options/config
#-

# Use tmux if inside
export FZF_TMUX_OPTS='-p80%,60%'

# Setup basic options (Color Catppuccin Mocha: https://github.com/catppuccin/fzf)
export FZF_DEFAULT_OPTS='
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
--reverse
--no-mouse
--cycle
--bind change:top
--bind ctrl-space:toggle+down
--bind alt-s:toggle-sort
--bind alt-p:toggle-preview
--bind alt-a:toggle-all
--bind alt-g:top
--bind ctrl-f:page-down
--bind ctrl-b:page-up
--bind ctrl-d:half-page-down
--bind ctrl-u:half-page-up
--bind shift-down:preview-down
--bind shift-up:preview-up
--bind alt-j:preview-down
--bind alt-k:preview-up
--bind alt-J:preview-page-down
--bind alt-K:preview-page-up'

# Use fd if available
if command -v fd >/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
  export FZF_FILES_COMMAND="${FZF_DEFAULT_COMMAND} --type f"
  export FZF_DIRS_COMMAND="${FZF_DEFAULT_COMMAND} --type d"
fi

#-
#  Functions
#-

# Edit Git: Edit git files in current dir OR yadm if not in git dir
function eg {
  if git rev-parse --git-dir >/dev/null 2>&1; then
    git ls-files | fzf -m --preview "cat {}" | xargs "${EDITOR}"
  elif command -v yadm >/dev/null; then
    yadm ls-files | fzf -m --preview "cat {}" | xargs "${EDITOR}"
  else
    echo "Not in git dir" && return
  fi
}

#-
#  Keys
#-

test -r "/usr/share/doc/fzf/examples/key-bindings.zsh" && \
  . "/usr/share/doc/fzf/examples/key-bindings.zsh"
test -r "/usr/share/doc/fzf/examples/completion.zsh" && \
  . "/usr/share/doc/fzf/examples/completion.zsh"
