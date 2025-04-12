if ! command -v rg >/dev/null
    return
end

if status --is-interactive
    # Path to configuration file.
    set -x RIPGREP_CONFIG_PATH "$XDG_CONFIG_HOME/ripgrep/config"

    # Check dependencies for interactive searches
    if not type -q fzf
        return 0
    end

    # Default rg commands for integration with fzf.
    set -x FZF_RG_COMMAND 'noglob rg --files-with-matches --no-messages'
    set -x FZF_RG_PREVIEW 'noglob rg --pretty --context=10 2>/dev/null'

    # Search file contents for the given pattern and preview matches.
    # Selected entries are opened with the default opener.
    #
    # Usage: search <pattern> [rg-options...]
    function search
        if test (count $argv) -eq 0 -o (string match -q -r '^-.*' $argv[1])
            echo "fs: missing rg pattern"
            return 1
        end
        set -l pat $argv[1]
        set -e argv[1]

        set -l selected (\
            FZF_HEIGHT=(set -q FZF_HEIGHT; or echo '90%') \
            FZF_DEFAULT_COMMAND="$FZF_RG_COMMAND $argv '$pat'" \
            fzf \
                --multi \
                --preview "$FZF_RG_PREVIEW $argv '$pat' {}" \
                --preview-window=wrap)
        # Open selected files
        $EDITOR $selected
    end

    # Search files interactively and preview matches.
    # Selected entries are opened with the default opener.
    # NOTE: The optional directory MUST be given as first argument,
    # otherwise the behavior is undefined.
    #
    # Usage: search-interactive [dir] [rg-options...]
    function search-interactive
        set -l dir
        if test (count $argv) -gt 0 -a (string match -q -r '^-.*' $argv[1])
            set dir $argv[1]
            set -e argv[1]
        end

        set -l selected (\
            FZF_HEIGHT=(set -q FZF_HEIGHT; or echo '90%') \
            FZF_DEFAULT_COMMAND="rg --files $argv $dir" \
            fzf \
                --multi \
                --phony \
                --bind "change:reload:$FZF_RG_COMMAND {q} $argv $dir || true" \
                --preview "$FZF_RG_PREVIEW {q} {} $argv" \
                --preview-window=wrap \
                | cut -d":" -f1,2)
        # Open selected files
        $EDITOR $selected
    end

    # Usability aliases.
    abbr -a fs search
    abbr -a ff search-interactive
end
