if ! command -v tmux >/dev/null
    return
end

if status --is-login
    # Path to the root tmux config file.
    # Using this will bypass the system-wide configuration file, if any.
    set -x TMUX_CONFIG "$XDG_CONFIG_HOME/tmux/tmux.conf"

    # Path to tmux internal dirs
    set -x TMUX_DATA_DIR "$XDG_DATA_HOME/tmux"
    set -x TMUX_CACHE_DIR "$XDG_STATE_HOME/tmux"

    # Path to the tmux directory to source other configuration files.
    set -x TMUX_CONFIG_DIR (dirname $TMUX_CONFIG)
end

if status --is-interactive
    # tmux command wrapper to load with config
    function tmux
        command tmux -2 -f $TMUX_CONFIG $argv
    end

    # tm [name]: Attach session or create it if it doesn't exist
    #   - If no name is provided, use fzf to select one
    function tm
        if test -n "$TMUX"
            set change switch-client
        else
            set change attach-session
        end
        if test -n "$argv[1]"
            tmux $change -t "$argv[1]" 2>/dev/null
            or begin
                tmux new-session -d -s "$argv[1]"
                tmux $change -t "$argv[1]"
            end
        else if command -qv fzf
            set session (tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0)
            tmux $change -t "$session"
            or echo "No sessions found."
        end
    end

    # List tmux sessions
    abbr -a tl "tmux ls"

    # Automatically start/attach to tmux. Possible values are:
    # - local   enable when starting zsh in a local terminal.
    # - remote  enable when starting zsh over a SSH connection.
    # - always  both of the above.
    # Set to any other value to disable.
    or set -q TMUX_AUTOSTART; and set -x TMUX_AUTOSTART "always"

    # Define what to do when autostarting. Possible values are:
    # - background      do not prompt and run a regular shell.
    # - attach          do not prompt and attach to tmux.
    # - prompt          prompt to attach or run a regular shell.
    # Note that the tmux server is started in the background regardless of this option.
    # This is useful to be properly welcomed to the terminal while the tmux session is
    # being restored, e.g. with tmux-resurrect/continuum.
    or set -q TMUX_AUTOSTART_MODE; and set -x TMUX_AUTOSTART_MODE "attach"

    # The name of the default created session if none are defined in the tmux config.
    or set -q TMUX_DEFAULT_SESSION; and set -x TMUX_DEFAULT_SESSION "main"

    # Figure out the TERM to use inside tmux.
    if tput setb24 >/dev/null 2>&1
        set -x TMUX_TERM $TERM
    else if test (tput colors) -ge 256
        set -x TMUX_TERM tmux-256color
    else
        set -x TMUX_TERM tmux
    end

    # Autostart tmux and attach to a session, if enabled and not already in tmux.
    # Attempt to detect whether the terminal is started from within another application.
    # In xterm (or terminals mimicking it), WINDOWID is set to 0 if the terminal is not
    # running in a X window (e.g. in a KDE application).
    set valid_term false
    set valid_remote false
    set valid_local false
    if test -z "$TMUX" -a -z "$NVIM" -a "$TERM" != "linux" -a (tty) != "/dev/tty[0-9]*"
        set valid_term true
    end
    if test -n "$SSH_TTY"; and test "$TMUX_AUTOSTART" = "always" -o "$TMUX_AUTOSTART" = "remote"
        set valid_remote true
    end
    if test -z "$SSH_TTY"; and test "$TMUX_AUTOSTART" = "always" -o "$TMUX_AUTOSTART" = "local"
        set valid_local true
    end

    if $valid_term; and $valid_remote || $valid_local
        # Start the tmux server, this is only useful if a session is created in the tmux config.
        # Otherwise the server will exit immediately (unless exit-empty is turned off).
        tmux start-server

        # Create the default session if no session has been defined in tmux.conf.
        if not tmux has-session >/dev/null 2>&1
            tmux new-session -ds "$TMUX_DEFAULT_SESSION"
        end

        # Perform the action defined by the selected autostart mode.
        set attach false
        if test "$TMUX_AUTOSTART_MODE" = attach
            set attach true
        else if string match -q -r "prompt*" "$TMUX_AUTOSTART_MODE"
            # Interactively ask to enter tmux or a regular shell.
            set ans n
            echo -n ":: Attach to tmux session? [Y/n] "
            read -l ans
            if string match -q -r "^[Yy]" $ans
                set attach true
            end
        end

        # Attach to the default session or to the most recently used unattached session.
        if $attach
            exec tmux attach-session
        end
    end
end
