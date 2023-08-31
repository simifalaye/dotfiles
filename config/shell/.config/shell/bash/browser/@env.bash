# shellcheck shell=bash

# Define the default web browser.
if [ -n "${DISPLAY}" ]; then
  export BROWSER=firefox
else
  export BROWSER=elinks
fi

# Use XDG base dir spec
export ELINKS_CONFDIR="${XDG_CONFIG_HOME}/elinks"
