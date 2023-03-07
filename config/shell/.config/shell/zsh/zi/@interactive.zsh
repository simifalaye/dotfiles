# shellcheck shell=zsh

# Paths for the zi installation.
typeset -gAH ZI
ZI[HOME_DIR]=${ZDATADIR}/zinit
ZI[BIN_DIR]="$ZI[HOME_DIR]/bin"
ZI[ZCOMPDUMP_PATH]="${ZCACHEDIR}/zcompdump"

# Paths for programs installed via zi.
ZPFX="$ZI[HOME_DIR]/prefix"
ZI[MAN_DIR]="$ZI[HOME_DIR]/man"

# Load repo and source zinit
load_repo z-shell/zi "$ZI[BIN_DIR]"
source $ZI[BIN_DIR]/zi.zsh || return 1

# Remove redundant zi aliases and functions.
unalias zini
unfunction zpcdclear zpcdreplay zpcompdef zpcompinit

# Install zi annexes.
zi light-mode depth=1 for \
    id-as'annex/bin-gem-node' z-shell/z-a-bin-gem-node \
    id-as'annex/linkbin'      z-shell/z-a-linkbin \
    id-as'annex/patch-dl'     z-shell/z-a-patch-dl

# Install zi consolette for plugin management.
zi light-mode wait'0c' lucid depth=1 trackbinds for \
    id-as'lib/zui' blockf bindmap'^O^Z -> hold' z-shell/zui \
    id-as'app/ziconsole'  bindmap'^O^J -> ^O^Z' z-shell/zi-console
