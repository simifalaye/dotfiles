#!/usr/bin/env bash
# Run with `source bootstrap.sh` OR `source <(wget -qO- <URL>/bootstrap.sh)`

# Constants
REPO_NAME="simifalaye/dotfiles"
CLONE_DIR="${HOME}/.dotfiles"
GIT_CONFIG_DIR="${HOME}/.config/git"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

#
# Helper Functions
#

step() { echo -e "${BLUE}:: $*${NC}" >&2; }
sub_step() { echo -e "  ${BLUE}:: $*${NC}" >&2; }
success() { echo -e "${GREEN}✔ $*${NC}" >&2; }
warn() { echo -e "${YELLOW}⚠ $*${NC}" >&2; }
error() { echo -e "${RED}✖ $*${NC}" >&2 >&2; }
abort() { error "$@" && return 1; }
usage() {
  echo "usage: $0 -g <email> -s <email> [keyname] [-s <email> [keyname] ...]"
  echo "  -g,--git-email <email> => Override the git email in the config"
  echo "  -s,--ssh-key <email> => Generate an ssh key"
  echo "  -h,--help => Display help"
  abort ""
}

#
# Main
#

set -e

# Reset all variables that might be set
SSH_KEYS=()
GIT_EMAIL=""

while [[ $# -gt 0 ]]; do
  case $1 in
  -g | --git-email)
    if [ -n "$2" ]; then
      GIT_EMAIL=$2
      shift
    else
      abort "-g|--git-email needs <email>"
    fi
    ;;
  -s | --ssh-key)
    if [[ $# -lt 2 ]]; then
      abort "-s|--ssh-key needs <email> [keyname]"
    fi
    email="$2"
    shift
    keyname=""
    if [ $# -eq 2 ]; then
      keyname="$2"
      shift
    fi
    SSH_KEYS+=("$email:$keyname")
    ;;
  -h | --help)
    usage
    ;;
  -?*)
    warn "Unknown option (ignored): ${1}"
    ;;
  *)
    break
    ;;
  esac
done

step "Installing core dependencies"
if [[ "$OSTYPE" == "darwin"* ]]; then
  sub_step "Detected Darwin machine, installing core deps"
  if ! command -v brew >/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if test -r /opt/homebrew/bin/brew; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif test -r /usr/local/bin/brew; then
      eval "$(/usr/local/bin/brew shellenv)"
    else
      abort "Homebrew install not found"
    fi
    success "Homebrew installed"
  fi
elif [[ "$OSTYPE" == "linux-gnu"* ]] && [ -f /etc/os-release ]; then
  # shellcheck source=/dev/null
  . /etc/os-release
  __os_id="$(echo "${ID}" | tr '[:upper:]' '[:lower:]')"
  case "$__os_id" in
    ubuntu|debian)
      sub_step "Detected Ubuntu/Debian machine, installing core deps"
      sudo apt update
      sudo apt install software-properties-common
      sudo apt install -y git zsh xz-utils build-essential wget curl
      success "Installed core deps"
      ;;
    arch)
      sub_step "Detected Arch machine, installing core deps"
      sudo pacman -S git zsh base-devel wget curl
      success "Installed core deps"
      ;;
    centos|rhel|fedora)
      __dnf="dnf"
      if ! command -v dnf >/dev/null 2>&1; then
        __dnf="yum"
      fi
      sub_step "Detected CentOS/RHEL/Fedora machine, installing core deps"
      if [ -f /etc/centos-release ]; then
        sudo "${__dnf}" install -y epel-release
      fi
      sudo "${__dnf}"  install -y git zsh wget curl
      sudo "${__dnf}"  groupinstall -y 'Development Tools'
      success "Installed core deps"
      ;;
    opensuse*|suse*)
      sub_step "Detected SUSE machine, installing core deps"
      sudo zypper install git zsh wget curl
      sudo zypper install -t pattern devel_basis
      success "Installed core deps"
      ;;
    *)
      error "Unsupported or unknown Linux distribution (ID='$__os_id')." && return 1
      ;;
  esac
else
  error "Unsupported OS: $OSTYPE" && return 1
fi
success "Installed core dependencies"

# Override git email
if [ -n "$GIT_EMAIL" ]; then
  step "Overriding default git email"
  mkdir -p "${GIT_CONFIG_DIR}"
  git_override_file="${GIT_CONFIG_DIR}/config.local"
  touch "${git_override_file}"
  cat <<EOF >> "${git_override_file}"

  [user]
  email = "$GIT_EMAIL"
EOF
fi

# Generate SSH key pairs
if [[ ${#SSH_KEYS[@]} -ne 0 ]]; then
  step "Generating ssh keys"
  # Start ssh-agent
  eval "$(ssh-agent -s)"

  # Create ssh dir if it doesn't exist
  ssh_dir="$HOME/.ssh"
  mkdir -p "$ssh_dir"
  chmod 700 "$ssh_dir"

  # Generate keys
  keypath="${ssh_dir}/id_ed25519"
  for entry in "${SSH_KEYS[@]}"; do
    email="${entry%%:*}"
    keyname="${entry##*:}"
    if [ -n "$keyname" ]; then
      keypath="${ssh_dir}/${keyname}"
    fi

    sub_step "Generating SSH key $keypath (email: $email)"
    ssh-keygen -t ed25519 -C "$email" -f "$keypath" -N ""
    ssh-add "$keypath"

    echo
    echo "=== SSH Key: $keypath ==="
    echo "Public Key:"
    echo
    cat "${keypath}.pub"
    echo
    echo "If needed, copy this key to GitHub (https://github.com/settings/keys)"
    echo "Press any key when you're done"
    read -r -n 1
    echo
  done
  success "SSH keys created, added to agent, and config updated.\n\
    To clone with alt identities, use: git@github-alt1:username/repo.git"
fi

# Clone the repository using SSH
if ! test -d "${CLONE_DIR}"; then
  step "Cloning dotfiles repo"
  git clone git@github.com:"${REPO_NAME}".git "${CLONE_DIR}"
  git submodule update --init --recursive
  step "Cloned dotfiles repo"
fi

step "Switching to dotfiles directory"
cd "${CLONE_DIR}" || return 1
