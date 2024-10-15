if (( ! $+commands[aws] )); then
  return
fi

#
# OhMyZsh aws plugin
#

SHOW_AWS_PROMPT=false
znap source ohmyzsh/ohmyzsh plugins/aws
