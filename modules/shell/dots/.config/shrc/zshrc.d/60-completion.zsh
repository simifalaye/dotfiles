#
# Completion configuration module for zsh.
#

# Configure completion on a non-dumb terminal
[[ ${TERM} == dumb ]] && return

#
# Load completion
#

zdumpfile="${ZCACHEDIR}/zcompdump"

# Check if dumpfile is up-to-date by comparing the full path and
# last modification time of all the completion functions in fpath.
local -i zdump_dat=1
LC_ALL=C local -r zcomps=(${^fpath}/^([^_]*|*~|*.zwc)(N))
if (( ${#zcomps} )); then
  zmodload -F zsh/stat b:zstat
  zstat -A zstats +mtime ${zcomps}
fi
local -r znew_dat=${ZSH_VERSION}$'\0'${(pj:\0:)zcomps}$'\0'${(pj:\0:)zstats}
if [[ -e ${zdumpfile}.dat ]]; then
  zmodload -F zsh/system b:sysread
  sysread -s ${#znew_dat} zold_dat <${zdumpfile}.dat
  [[ ${zold_dat} == ${znew_dat} ]]; zdump_dat=${?}
fi
if (( zdump_dat )) command rm -f ${zdumpfile}(|.dat|.zwc(|.old))(N)

# Run compinit
autoload -Uz compinit && compinit -C -d ${zdumpfile}

if [[ ! ${zdumpfile}.dat -nt ${zdumpfile} ]]; then
  >! ${zdumpfile}.dat <<<${znew_dat}
fi
# Compile the completion dumpfile; significant speedup
if [[ ! ${zdumpfile}.zwc -nt ${zdumpfile} ]] zcompile ${zdumpfile}

#
# Options
#

# Move cursor to end of word if a full completion is inserted.
setopt ALWAYS_TO_END

# Don't beep on ambiguous completions.
setopt NO_LIST_BEEP

# Enable additional glob operators. (Globbing = pattern matching)
# https://zsh.sourceforge.io/Doc/Release/Expansion.html#Filename-Generation
setopt EXTENDED_GLOB

# Make globbing (filename generation) insensitive to case
setopt NO_CASE_GLOB

#
# Completion module settings
#

# Enable caching
zstyle ':completion::complete:*' use-cache on

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group yes
zstyle ':completion:*:options' description yes
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format '%F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
zstyle ':completion:*' format '%F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' '+r:|?=**'

# Ignore useless commands and functions
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec)|prompt_*)'
# Array completion element sorting.
zstyle ':completion:*:*:-subscript-:*' tag-order 'indexes' 'parameters'

# Directories
if (( ${+LS_COLORS} )); then
  zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
else
  # Use same LS_COLORS definition from utility module, in case it was not set
  zstyle ':completion:*:default' list-colors ${(s.:.):-di=1;34:ln=35:so=32:pi=33:ex=31:bd=1;36:cd=1;33:su=30;41:sg=30;46:tw=30;42:ow=30;43}
fi
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*' squeeze-slashes true

# History
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# Populate hostname completion.
zstyle -e ':completion:*:hosts' hosts 'reply=(
${=${=${=${${(f)"$(cat {/etc/ssh/ssh_,~/.ssh/}known_hosts{,2} 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
${=${(f)"$(cat /etc/hosts 2>/dev/null; ypcat hosts 2>/dev/null)"}%%(\#)*}
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config{,.d/*(N)} 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
  )'

# Don't complete uninteresting users...
zstyle ':completion:*:*:*:users' ignored-patterns \
  '_*' adm amanda apache avahi beaglidx bin cacti canna clamav daemon dbus \
  distcache dovecot fax ftp games gdm gkrellmd gopher hacluster haldaemon \
  halt hsqldb ident junkbust ldap lp mail mailman mailnull mldonkey mysql \
  nagios named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
  operator pcap postfix postgres privoxy pulse pvm quagga radvd rpc rpcuser \
  rpm shutdown squid sshd sync uucp vcsa xfs

# ... unless we really want to.
zstyle ':completion:*' single-ignored show

# Ignore multiple entries.
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'

# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# Abort if requirements are not met.
(( $+functions[zcompile-many] )) || return 1

#
# Plugin: zsh-completions
#

# Install plugin
plugin_dir=${ZPLUGDIR}/zsh-completions
if [[ ! -e ${plugin_dir} ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-completions.git ${plugin_dir}
  zcompile-many ${plugin_dir}/zsh-completions.plugin.zsh
fi

# Load plugin
source ${plugin_dir}/zsh-completions.plugin.zsh
