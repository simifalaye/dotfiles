# shellcheck shell=zsh

# NOTE: Similarly to syntax-highlighting, this module wraps ZLE widgets and
# should be loaded after all widgets have been defined.
# For best results, syntax-highlighting should be loaded before so that
# highlighting is updated when the plugin updates the editor buffer.
# NOTE: Must be loaded after $keys array is defined using terminfo

if (( ! $+functions[zi] )); then
    return 1
fi

# Configure zsh-history-substring-search.
# This is provided as a function since the plugin is loaded asynchronously
# and does not support overriding the defaults.
function _configure_history_substring_search {
    # Half case-sensitive: lower matches upper, upper does not match lower.
    HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS=l

    # Rebind up/down keys to use the loaded widgets.
    bindkey "$keys[Up]" history-substring-search-up
    bindkey "$keys[Down]" history-substring-search-down
    bindkey "$keys[Ctrl]p" history-substring-search-up
    bindkey "$keys[Ctrl]n" history-substring-search-down

    unfunction _configure_history_substring_search
}

zi light-mode wait lucid for \
    id-as'plugin/zsh-history-substring-search' \
    depth=1 atload'_configure_history_substring_search' \
    @zsh-users/zsh-history-substring-search
