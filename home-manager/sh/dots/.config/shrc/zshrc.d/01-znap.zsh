# Download Znap, if it's not there yet
[[ -r "${ZDATADIR}"/znap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git "${ZDATADIR}"/znap

# Configure Znap
zstyle ':znap:*' repos-dir "${ZDATADIR}"/plugins
zstyle '*:compinit' arguments -d "${ZCACHEDIR}/zcompdump"

# Load Znap
source "${ZDATADIR}"/znap/znap.zsh
