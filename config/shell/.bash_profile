# vim: filetype=bash
# Bash startup files order:
#   https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html

# Bash does not read ~/.bashrc in a login shell even if it is interactive.
if [[ $- == *i* ]]; then
  test -r "${HOME}/.bashrc" && . "${HOME}/.bashrc"
fi
