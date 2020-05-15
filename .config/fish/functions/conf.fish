function conf
    if count $argv > /dev/null
        set files (find $HOME/.config/$argv[1] -maxdepth 1 -type f)
        $EDITOR $files
    else
        cd $HOME/.config && ls
    end
end
