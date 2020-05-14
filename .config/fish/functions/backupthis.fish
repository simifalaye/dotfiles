function backupthis
    set f $argv[1]
    cp -riv $f $f-(date +%Y%m%d%H%M).backup;
end
