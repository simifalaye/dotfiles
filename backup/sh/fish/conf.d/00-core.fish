#
# Env
#

# XDG base directory ENV
# References:
# * https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
# * https://wiki.archlinux.org/index.php/XDG_Base_Directory
set -x XDG_CONFIG_HOME "$HOME/.config" && mkdir -p "$XDG_CONFIG_HOME"
set -x XDG_CACHE_HOME "$HOME/.cache" && mkdir -p "$XDG_CACHE_HOME"
set -x XDG_DATA_HOME "$HOME/.local/share" && mkdir -p "$XDG_DATA_HOME"
set -x XDG_STATE_HOME "$HOME/.local/state" && mkdir -p "$XDG_STATE_HOME"
set -x XDG_RUNTIME_DIR "/tmp/runtimedir/$UID" && mkdir -p "$XDG_RUNTIME_DIR"
set -x XDG_CONFIG_DIRS /etc/xdg && mkdir -p "$XDG_CONFIG_DIRS"
set -x XDG_DATA_DIRS "/usr/local/share:/usr/share"

#
# Login
#

if status --is-login
    # Prepend user binaries to PATH to allow overriding system commands.
    set PATH "$HOME/.local/bin:" $PATH

    # Set the browser
    if test -n "$DISPLAY"
        set -x BROWSER firefox
    else
        set -x BROWSER elinks
    end

    # Set the default editor
    set -x EDITOR vi
    set -x GIT_EDITOR "$EDITOR"
    set -x USE_EDITOR "$EDITOR"
    set -x VISUAL "$EDITOR"

    # Set the default pager
    set -x PAGER less

    # Set less config
    set -x LESSHISTFILE "$XDG_STATE_HOME/less/history"
    set -x LESSKEY "$XDG_STATE_HOME/less/key"
    set -x LESSHISTSIZE 50
    set -x LESS "-QRSMi -#.25 --no-histdups"
    set -x SYSTEMD_LESS "$LESS"
    mkdir -p "$XDG_STATE_HOME/less" # Create less dir if not created

    # Wsl2
    if grep -iq microsoft /proc/version
        # Escape path
        set -x PATH (string replace ' ' '\\ ' $PATH)
        set -x LS_COLORS "ow=01;36;40"
        set -x LIBGL_ALWAYS_INDIRECT 1
        # pam_env
        set -x RUNLEVEL 3
        # Use explorer.exe for browser
        set -x BROWSER "/mnt/c/Windows/explorer.exe"
    end
end

#
# Interactive
#

if status --is-interactive
    # Cd to last directory
    abbr -a - 'cd -'

    # Elementary.
    abbr -a reload "exec $SHELL -l" # reload the current shell configuration
    abbr -a su 'su -l' # safer, simulate a real login

    # Human readable output.
    abbr -a ls 'ls --color=auto'
    abbr -a dir 'dir --color=auto'
    abbr -a vdir 'vdir --color=auto'
    abbr -a diff 'diff --color=auto'
    abbr -a grep 'grep --color=auto'
    abbr -a fgrep 'fgrep --color=auto'
    abbr -a egrep 'egrep --color=auto'
    abbr -a df 'df -h' du='du -h'

    # Verbose and safe file operations.
    abbr -a cp 'cp -vi'
    abbr -a mv 'mv -vi'
    abbr -a ln 'ln -vi'
    abbr -a rm 'rm -vI'

    # Directory listing.
    abbr -a dud 'du -d1' # show total disk usage for direct subdirectories only
    abbr -a ls 'ls --color=auto --group-directories-first' # list directories first
    abbr -a ll 'ls -lh' # list human readable sizes
    abbr -a l 'll -A' # list human readable sizes, all files
    abbr -a lr 'll -R' # list human readable sizes, recursively
    abbr -a lx 'll -XB' # list sorted by extension (GNU only)
    abbr -a lk 'll -Sr' # list sorted by size, largest last
    abbr -a lt 'll -tr' # list sorted by modification time, most recent last

    # Making/Changing directories.
    abbr -a mkdir 'mkdir -pv'
    abbr -a mkd mkdir
    abbr -a rmd rmdir

    # Systemd convenience.
    abbr -a sc systemctl
    abbr -a scu 'sc --user'
    abbr -a jc 'journalctl --catalog'
    abbr -a jcb 'jc --boot=0'
    abbr -a jcf 'jc --follow'
    abbr -a jce 'jc -b0 -p err..alert'

    # Simple progress bar output for downloaders by default.
    abbr -a curl 'curl --progress-bar'
    abbr -a wget 'wget -q --no-hsts --show-progress'

    # Simple and silent desktop opener.
    abbr -a open 'nohup xdg-open </dev/null >|$(mktemp --tmpdir nohup.XXXX) 2>&1'
    abbr -a o open

    # Pipe helpers
    abbr -a --position anywhere H "| head"
    abbr -a --position anywhere T "| tail"
    abbr -a --position anywhere G "| grep"
    abbr -a --position anywhere L "| $PAGER"
    abbr -a --position anywhere LL "2>&1 | less"
    abbr -a --position anywhere CA "2>&1 | cat -A"
    abbr -a --position anywhere NE "2>/dev/null"
    abbr -a --position anywhere NUL ">/dev/null 2>&1"
    abbr -a --position anywhere -- HP "--help"
    abbr -a --position anywhere -- VR "--version"

    function b
        bash -c (read)
    end
end

#
# Logout
#

set -g logout_functions

function on_exit --on-event fish_exit
    # When leaving the console, clear the screen to increase privacy
    if test "$SHLVL" = 1
        if test -x /usr/bin/clear_console
            /usr/bin/clear_console -q
        end
    end
    # Run other logout functions
    for func in $logout_functions
        eval $func
    end
end
