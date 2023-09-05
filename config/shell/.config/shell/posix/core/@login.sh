# shellcheck shell=sh

export NAME="Simi Falaye"
export EMAIL="simifalaye1@gmail.com"

#-
#  XDG base directory ENV
#  References:
#  * https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
#  * https://wiki.archlinux.org/index.php/XDG_Base_Directory
#-

# wget
export WGETRC="${XDG_CONFIG_HOME}/wget/config"
mkdir -p "${XDG_CONFIG_HOME}/wget"

# iceauth/xauth
export ICEAUTHORITY="${XDG_CACHE_HOME}/ICEauthority"
if [ -f "$XDG_CACHE_HOME/Xauthority" ]; then
  # X server auth cookie
  export XAUTHORITY="${XDG_CACHE_HOME}/Xauthority"
fi
