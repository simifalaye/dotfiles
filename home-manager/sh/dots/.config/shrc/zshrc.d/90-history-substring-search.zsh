#
# NOTE: This module wraps ZLE widgets and should be loaded after all
# widgets have been defined. Namely, after the 'input' module. For
# best results, syntax-highlighting should be loaded before so that
# highlighting is updated when the plugin updates the editor buffer.
#

[[ -o interactive ]] || return 0

#
# zsh-history-substring-search plugin
#

# Half case-sensitive: lower matches upper, upper does not match lower.
HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS=l

# Load plugin
znap source zsh-users/zsh-history-substring-search

# Rebind up/down keys to use the loaded widgets.
if typeset -p key_info > /dev/null 2>&1; then
  bindkey "$key_info[Up]" history-substring-search-up
  bindkey "$key_info[Down]" history-substring-search-down
  bindkey "$key_info[Ctrl]p" history-substring-search-up
  bindkey "$key_info[Ctrl]n" history-substring-search-down
fi
