if ! command -v eza >/dev/null
    return
end

if status --is-login
    # Setup colors
    export EZA_COLORS='da=1;34:gm=1;34'
end

if status --is-interactive
    # Quick switch to opt-in git support.
    function eza
        command eza --git $argv
    end

    function ls --description 'List contents of directory'
        eza --group-directories-first $argv
    end

    function l
        ls -l $argv
    end

    # Override original aliases with similar, yet improved behavior.
    abbr -a lsa "ls -a" # short list, hidden files
    abbr -a ll "ls -lGh" # list as a grid with header
    abbr -a la "l -a" # list hidden files
    abbr -a lr "l -T" # list recursively as a tree
    abbr -a lv "l --git-ignore" # list git-versioned files
    abbr -a lx "l --sort=ext" # list sorted by extension
    abbr -a lk "l --sort=size" # list sorted by size, largest last
    abbr -a lt "l --sort=mod" # list sorted by modification time, most recent last
    abbr -a ltc "l --sort=ch --time=ch" # list sorted by change time, most recent last
    abbr -a lta "l --sort=acc --time=acc" # list sorted by access time, most recent last
end
