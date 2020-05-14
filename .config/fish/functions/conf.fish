function conf
    if count $argv > /dev/null
        $EDITOR $HOME/.config/$argv[1]
    else
        cd $HOME/.config && ls
    end
end
