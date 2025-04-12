#
# Fetch a weather forecast using the awesome wttr.in.
#
function weather
    set location ''
    set lang (string split -m1 '_' -- $LANG)[1]
    set rich ''

    while test (count $argv) -gt 0
        switch $argv[1]
            case '-h' '--help'
                echo 'Usage: weather [-r|--rich] [location] [language]'
                echo '\nOptions:'
                echo '  -r, --rich  Use experimental data-rich format'
                echo '\nService help follows...'
                curl -s wttr.in/:help
                return
            case '-r' '--rich'
                set rich 1
            case '*'
                if test -z "$location"
                    set location $argv[1]
                else
                    set lang $argv[1]
                end
        end
        set argv $argv[2..-1]
    end

    set request "wttr.in/$location?F"
    if test $COLUMNS -lt 125
        set request "$request&n"
    end
    if test -n "$rich"
        set request "$request&format=v2"
    end
    curl -s -H "Accept-Language: $lang" --compressed $request
end
