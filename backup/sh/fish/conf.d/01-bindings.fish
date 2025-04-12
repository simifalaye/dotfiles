function fish_user_key_bindings
    fish_default_key_bindings

    # Toggle process as bg and fg
    bind \cz 'fg 2>/dev/null; commandline -f repaint'
end
