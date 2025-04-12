if ! command -v tinty >/dev/null
    return
end

if status --is-login
    # Set environment variables
    set -x TINTY_DATA_DIR "$XDG_DATA_HOME/tinted-theming/tinty"
    set -x TINTY_CURRENT_FILE "$TINTY_DATA_DIR/current_scheme"
end

if status --is-interactive
    # Function to source shell theme
    function tinty
        set newer_file (mktemp)
        command tinty $argv
        set subcommand $argv[1]

        if test "$subcommand" = apply -o "$subcommand" = init
            for script in (find $TINTY_DATA_DIR -maxdepth 1 -type f -name "*.sh" -newer $newer_file)
                source $script
            end
        end

        set -e subcommand
    end

    # Check if tinty command exists
    if command -qv tinty
        if not test -d "$XDG_DATA_HOME/tinted-theming/tinty"
            tinty install
        end

        # Only run in valid term
        if test -z "$TMUX" -a -z "$NVIM" -a "$TERM" != linux -a (tty) != "/dev/tty[0-9]*"
            tinty init >/dev/null
        end
    end
end
