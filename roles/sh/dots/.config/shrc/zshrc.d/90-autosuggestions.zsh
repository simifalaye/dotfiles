#
# NOTE: This module wraps ZLE widgets and should be loaded after all
# widgets have been defined. Namely, after the 'input' module. For
# best results, syntax-highlighting should be loaded before so that
# highlighting is updated when the plugin updates the editor buffer.
#

[[ -o interactive ]] || return 0

#
# zsh-autosuggestions plugin
#

# Disable highlighting for terminals with 8-color or less.
(( $terminfo[colors] <= 8 )) && ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=''

# Fetch suggestions asynchronously.
ZSH_AUTOSUGGEST_USE_ASYNC=y

# Load plugin
znap source zsh-users/zsh-autosuggestions

# Bind C-Space to accept autosuggestion
bindkey "$key_info[Ctrl] " autosuggest-accept
