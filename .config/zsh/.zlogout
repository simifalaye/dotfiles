# .zlogout is executed by zsh(1) on interactive log out

test -r $SHELL_CONF_HOME/shell-logout && source $SHELL_CONF_HOME/shell-logout
