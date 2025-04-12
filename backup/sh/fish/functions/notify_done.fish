function __run_powershell_script
    set -l powershell_exe (command --search "powershell.exe")

    if test $status -ne 0
        and command --search wslvar

        set -l powershell_exe (wslpath (wslvar windir)/System32/WindowsPowerShell/v1.0/powershell.exe)
    end

    if string length --quiet "$powershell_exe"
        and test -x "$powershell_exe"

        set cmd (string escape $argv)

        eval "$powershell_exe -Command $cmd"
    end
end

function __windows_notification -a title -a message
    __run_powershell_script "
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
[Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null

\$toast_xml_source = @\"
    <toast>
        $soundopt
        <visual>
            <binding template=\"ToastText02\">
                <text id=\"1\">$title</text>
                <text id=\"2\">$message</text>
            </binding>
        </visual>
    </toast>
\"@

\$toast_xml = New-Object Windows.Data.Xml.Dom.XmlDocument
\$toast_xml.loadXml(\$toast_xml_source)

\$toast = New-Object Windows.UI.Notifications.ToastNotification \$toast_xml

[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier(\"fish\").Show(\$toast)
"
end

function notify_done
    set -l cmd $argv
    set -l start_time (date +%s)

    # Run the command & get the exit status
    eval $cmd
    set -l exit_status $status

    set -l end_time (date +%s)
    set -l duration (math $end_time - $start_time)

    set -l title "Done in $duration seconds"
    set -l wd (string replace --regex "^$HOME" "~" (pwd))
    set -l message "$wd: $cmd"

    if test $exit_status -ne 0
        set title "Failed ($exit_status) after $duration seconds"
    end

    if test -n "$TMUX_PANE"
        set message (tmux lsw  -F"[#{window_index}]" -f '#{==:#{pane_id},'$TMUX_PANE'}')" $message"
    end

    if set -q KITTY_WINDOW_ID
        printf "\x1b]99;i=done:d=0;$title\x1b\\"
        printf "\x1b]99;i=done:d=1:p=body;$message\x1b\\"
    else if type -q osascript # AppleScript
        # escape double quotes that might exist in the message and break osascript. fixes #133
        set -l message (string replace --all '"' '\"' "$message")
        set -l title (string replace --all '"' '\"' "$title")

        osascript -e "display notification \"$message\" with title \"$title\""
    else if type -q notify-send # Linux notify-send
        # set urgency to normal
        set -l urgency normal

        # override user-defined urgency level if non-zero exitstatus
        if test $exit_status -ne 0
            set urgency critical
        end

        notify-send --hint=int:transient:1 --urgency=$urgency --icon=utilities-terminal --app-name=fish "$title" "$message"
    else if type -q notify-desktop # Linux notify-desktop
        set -l urgency
        if test $exit_status -ne 0
            set urgency "--urgency=critical"
        end
        notify-desktop $urgency --icon=utilities-terminal --app-name=fish "$title" "$message"
    else if uname -a | string match --quiet --ignore-case --regex microsoft
        __windows_notification "$title" "$message"
    else # anything else
        echo -e "\a" # bell sound
    end
end
