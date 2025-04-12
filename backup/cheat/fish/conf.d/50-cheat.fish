if ! command -v cht.sh >/dev/null
    return
end

if status --is-interactive
  abbr -a ch 'cht.sh'
end
