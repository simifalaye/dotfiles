#
# Plugin: z -- Jump to commonly accessed directories
#

# Abort if requirements are not met
[[ -o interactive ]] || return 1

# Config
export _Z_DATA="${ZDATADIR}/z"

# Load plugin
plugin_dir=${ZPLUGDIR}/z
if [[ ! -e ${plugin_dir} ]]; then
  git clone --depth=1 https://github.com/rupa/z.git ${plugin_dir}
fi
source ${plugin_dir}/z.sh
