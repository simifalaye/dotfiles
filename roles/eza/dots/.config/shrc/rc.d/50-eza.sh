# Setup colors
export EZA_COLORS='da=1;34:gm=1;34'

# Quick switch to opt-in git support.
alias eza='eza --git'

# Override original aliases with similar, yet improved behavior.
alias ls='eza --group-directories-first' # list directories first by default
alias lsa='ls -a'                        # short list, hidden files
alias l='ls -l'                          # list in long format
alias ll='ls -lGh'                       # list as a grid with header
alias la='l -a'                          # list hidden files
alias lr='l -T'                          # list recursively as a tree
alias lv='l --git-ignore'                # list git-versioned files
alias lx='l --sort=ext'                  # list sorted by extension
alias lk='l --sort=size'                 # list sorted by size, largest last
alias lt='l --sort=mod'                  # list sorted by modification time, most recent last
alias ltc='l --sort=ch --time=ch'        # list sorted by change time, most recent last
alias lta='l --sort=acc --time=acc'      # list sorted by access time, most recent last
