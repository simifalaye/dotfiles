#!/bin/sh
# - Installs required apps:
#   - curl
#   - git
#   - gnu-stow
#   - ansible (2.14+)
#   - ansible community.general
# - Clone dotfiles repo

#-
#  Main
#-

# Install required apps
OS="$(uname)"
case $OS in
    'Darwin')
        echo "Detected macOS"
        brew update
        brew install ansible curl git stow
        ;;
    'Linux')
        echo "Detected Linux"
        if [ -f /etc/os-release ]; then
            # Debian/Ubuntu/Linux Mint
            if grep -q -E '(debian|ubuntu|linuxmint)' /etc/os-release; then
                echo "Detected Debian/Ubuntu/Linux Mint"
                sudo add-apt-repository --yes --update ppa:ansible/ansible
                sudo apt-get update
                sudo apt-get install -y curl git stow software-properties-common
                sudo apt-get install -y ansible
                sudo ansible-galaxy collection install community.general
                # CentOS/RHEL/Fedora
            elif grep -q -E '(centos|rhel|fedora)' /etc/os-release; then
                echo "Detected CentOS/RHEL/Fedora"
                if [ -f /etc/centos-release ]; then
                    sudo yum update
                    sudo yum install -y epel-release
                fi
                sudo yum install -y ansible curl git stow
                sudo ansible-galaxy collection install community.general
                # Arch
            elif grep -q -E '(arch)' /etc/os-release; then
                echo "Detected Arch"
                sudo pacman -Syyu --noconfirm ansible curl git stow
                sudo ansible-galaxy collection install community.general
                # openSUSE
            elif grep -q -E '(opensuse)' /etc/os-release; then
                echo "Detected openSUSE"
                sudo zypper update
                sudo zypper install -y ansible curl git stow
                sudo ansible-galaxy collection install community.general
            else
                echo "Unsupported Linux distribution"
                exit 1
            fi
        else
            echo "Unsupported Linux distribution"
            exit 1
        fi
        ;;
    *)
        echo "Unsupported OS"
        exit 1
        ;;
esac

# Clone dotfiles repo
git clone https://github.com/simifalaye/dotfiles.git ~/.dotfiles

echo "Installation complete."
