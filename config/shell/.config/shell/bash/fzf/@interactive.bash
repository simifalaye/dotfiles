# shellcheck shell=bash

if ! is_callable fzf; then
	return 1
fi

# Use tmux if inside
export FZF_TMUX=1

# Abstract away the fzf command for optional tmux integration.
function fzf {
	local height="${FZF_HEIGHT:-50%}"

	if [[ $TMUX_PANE && $FZF_TMUX ]]; then
		fzf-tmux -p $height -- "$@"
	else
		command fzf --height $height "$@"
	fi
}

# Setup basic options
export FZF_DEFAULT_OPTS='
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

# Add colors if supported
if [[ "$TERM" == *"256color"* ]]; then
	# Colors: https://github.com/catppuccin/fzf
	FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
	--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796
	--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6
	--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"'
fi

# Use fd if available
if is_callable fd; then
	export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
	export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
	export FZF_FILES_COMMAND="${FZF_DEFAULT_COMMAND} --type f"
	export FZF_DIRS_COMMAND="${FZF_DEFAULT_COMMAND} --type d"
fi

# Editor convinience aliases
if is_callable fzf; then
	# Edit Git: Edit git files in current dir OR yadm if not in git dir
	eg() {
		if git rev-parse --git-dir >/dev/null 2>&1; then
			git ls-files | fzf -m --preview "cat {}" | xargs "${EDITOR}"
		elif is_callable yadm; then
			yadm ls-files | fzf -m --preview "cat {}" | xargs "${EDITOR}"
		else
			echo "Not in git dir" && return
		fi
	}
fi

# Will be used by zsh module also
if [ -n "${BASH_SOURCE}" ]; then
	include /usr/share/doc/fzf/examples/key-bindings.bash
fi
