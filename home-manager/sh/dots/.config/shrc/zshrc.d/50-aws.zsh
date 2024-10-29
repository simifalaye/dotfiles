(( $+commands[aws] )) || return 0
(( $+functions[znap] )) || return 0

#
# OhMyZsh aws plugin
#

SHOW_AWS_PROMPT=false znap source ohmyzsh/ohmyzsh plugins/aws
