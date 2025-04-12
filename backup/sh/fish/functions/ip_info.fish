#
# Fetch information about a public IP address.
#
function ip_info
    set ip_address $argv[1]

    while test (count $argv) -gt 0
        switch $argv[1]
            case '-h' '--help'
                echo "Usage: ip-info [-p|--public] [addr]"
                echo "\nOptions:"
                echo "  -p, --public  Show public IP address only"
                return
            case '-p' '--public'
                curl -s ipinfo.io/ip
                return
        end
        set argv (commandline -ct $argv[2..-1])
    end

    curl -s ipinfo.io/$ip_address
    echo
end
