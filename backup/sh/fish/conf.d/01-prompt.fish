if status --is-interactive
	# Git prompt settings
	set __fish_git_prompt_showuntrackedfiles 'yes'
	set __fish_git_prompt_showdirtystate 'yes'
	set __fish_git_prompt_showstashstate ''
	set __fish_git_prompt_showupstream 'none'
	set -g fish_prompt_pwd_dir_length 3
end

function fish_prompt -d "Write out the prompt"
	set prev_status $status
    set prev_pipestatus $pipestatus

	# Date
	set_color brblack
	echo -n "["(date "+%H:%M")"] "

	# Hostname
	set_color blue
	echo -n (hostnamectl hostname)

	# Dirname
	if [ $PWD != $HOME ]
		set_color brblack
		echo -n ':'
		set_color yellow
		echo -n (basename $PWD)
	end

	# Git
	set_color green
	printf '%s ' (__fish_git_prompt)

	# Prompt character
	if test $prev_status -eq 0
		set_color magenta
	else
		set_color red
	end
	echo -n '| '

	# Input
	set_color normal
end
