#-
#  Options
#-

# Directory
shopt -s autocd # automatically change to directory if the command is a directory
shopt -s cdable_vars # allow automatic parameter expansion in cd context
shopt -s cdspell # allow automatic spelling correction in cd context
shopt -s dirspell # allow automatic spelling correction in pathname completion context

# Jobs
shopt -s checkjobs # report running/suspended jobs on shell exit
shopt -s huponexit # kill jobs with SIGHUP on shell exit

# Pattern matching
shopt -s extglob # enable pattern lists separated with '|' and related operators

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

#-
#  History
#-

shopt -s cmdhist # store multiline commands as one line
shopt -s histappend # append to history file
HISTCONTROL=ignoreboth # ignore duplicate lines in history
HISTFILE_DIR="${XDG_CACHE_HOME}/bash"
HISTIGNORE="&:ls:[bf]g:pwd:exit:cd .."
HISTFILE="$HISTFILE_DIR/history"
HISTSIZE=10000
HISTFILESIZE=20000
command mkdir -p "${HISTFILE_DIR}"

#-
#  Color/prompt
#-

# Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# Determine whether term supports color
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

# Set a color prompt
if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt

#-
#  Completions
#-

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
test -f /usr/share/bash-completion/bash_completion &&
  . /usr/share/bash-completion/bash_completion
test -f /etc/bash_completion && . /etc/bash_completion
