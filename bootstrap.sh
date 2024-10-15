#!/bin/bash
# Run with `source bootstrap.sh` OR `source <(wget -qO- <URL>/bootstrap.sh)`

# Constants
GITHUB_USER="simifalaye"
REPO_NAME="dotfiles-nix"
CLONE_DIR="${HOME}/dotfiles"
SSH_KEY="${HOME}/.ssh/id_ed25519"

# Reset all variables that might be set
email="simifalaye1@gmail.com"
nix_single_user=0

while :; do
  case $1 in
    -h|-\?|--help)
      echo "usage: $0 [-e]"
      echo "  -e,--email [email]  Email to use for ssh key"
      echo "  -h,--help           Display help"
      exit
      ;;
    -e|--email)
        if [ -n "$2" ]; then
          email=$2
          shift
        else
          printf 'ERROR: "--email" requires a non-empty option argument.\n' >&2
          exit 1
        fi
        ;;
    --nix-single-user)
      nix_single_user=1
      ;;
    --)
      shift
      break
      ;;
    -?*)
      printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
      ;;
    *)
      break
  esac
  shift
done

echo "## Running Bootstrap"
echo "## Email: ${email}"
echo "## Nix single user: ${nix_single_user}"

# Install dependencies
case "$(uname -s)" in
  Linux)
    if [ -f /etc/os-release ]; then
      if grep -q -E '(debian|ubuntu|linuxmint)' /etc/os-release; then
        echo "## Detected Debian/Ubuntu/LinuxMint machine, installing deps..."
        sudo apt update && sudo apt install -y zsh git xz-utils
      elif grep -q -E '(centos|rhel|fedora)' /etc/os-release; then
          echo "## Detected CentOS/RHEL/Fedora machine, installing deps..."
          if [ -f /etc/centos-release ]; then
            sudo yum update
            sudo yum install -y epel-release
          fi
          sudo yum install -y zsh git
      elif grep -q -E '(arch)' /etc/os-release; then
        echo "## Detected Arch machine, installing deps..."
        sudo pacman -S zsh git
      elif grep -q -E '(opensuse)' /etc/os-release; then
        echo "## Detected SUSE machine, installing deps..."
        sudo zypper install zsh git
      else
        echo "ERROR: Unsupported Linux distribution" && exit 1
      fi
    else
      echo "ERROR: Missing linux os-release file" && exit 1
    fi
    # Install nix
    if ! command -v nix >/dev/null; then
      if [ ${nix_single_user} -eq 1 ]; then
        sh <(curl -L https://nixos.org/nix/install) --no-daemon --yes
      else
        sh <(curl -L https://nixos.org/nix/install) --daemon --yes
      fi
    fi
    ;;
  Darwin)
    echo "## Detected Darwin machine, installing deps..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
      brew install zsh git
    # Install nix
    if ! command -v nix >/dev/null; then
      sh <(curl -L https://nixos.org/nix/install) --yes
    fi
    ;;
  *)
    echo "ERROR: Unsupported operating system" && exit 1
    ;;
esac

# Generate SSH key pair
if [ ! -f "${SSH_KEY}.pub" ]; then
  echo "## SSH key not detected, setting up key..."
  ssh-keygen -t ed25519 -C "${email}" -f "${SSH_KEY}"
  # Start the ssh-agent in the background
  eval "$(ssh-agent -s)"
  # Add SSH private key to the ssh-agent
  ssh-add "${SSH_KEY}"
fi

# Display the public key and prompt user to add it to GitHub
printf "## Please add the following SSH key to your GitHub account:\n"
cat "${SSH_KEY}.pub"
printf "## Visit https://github.com/settings/keys to add the key.\n"
printf "  Press [Enter] key after adding the key to GitHub..."
read -r dummy
[ -n "${dummy}" ] && echo ""

# Clone the repository using SSH
echo "## Cloning dotfiles repo..."
git clone git@github.com:"${GITHUB_USER}"/"${REPO_NAME}".git "${CLONE_DIR}"

# Switch to zsh
echo "## Setting zsh as default shell..."
chsh -s "$(which zsh)"

# Navigate to the cloned repository directory
cd "${CLONE_DIR}" || exit 1

# Restart shell to pull in nix
exec "$(which zsh)"
