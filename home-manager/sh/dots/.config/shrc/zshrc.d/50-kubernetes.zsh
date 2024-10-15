if (( ! $+commands[kubectl] )); then
  return
fi

#
# OhMyZsh kubectl/kubectx plugin
#

znap source ohmyzsh/ohmyzsh plugins/kubectl
znap source ohmyzsh/ohmyzsh plugins/kubectx
