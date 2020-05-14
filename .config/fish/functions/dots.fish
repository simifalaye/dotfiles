function dots
    set msg "latest updates"
    if count $argv > /dev/null
        set msg $argv[1]
    end
    command yadm commit -a -m "$msg"
    command yadm push
end
