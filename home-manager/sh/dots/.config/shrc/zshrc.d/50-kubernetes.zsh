(( $+commands[kubectl] )) || return 0
(( $+functions[znap] )) || return 0

#
# OhMyZsh kubectl/kubectx plugin
#

znap source ohmyzsh/ohmyzsh plugins/kubectl
znap source ohmyzsh/ohmyzsh plugins/kubectx
