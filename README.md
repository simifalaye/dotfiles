<h1 align="center">Dotfiles</h1>
<p align="center">My dotfiles</p>
<p align="center">
  <img src="https://img.shields.io/badge/OS-ubuntu_22.04-orange.svg" />
  <img src="https://img.shields.io/badge/Editor-vim-brightgreen.svg" />
  <img src="https://img.shields.io/badge/Shell-zsh-yellow.svg" />
  <br><br>
  <img src="https://i.imgur.com/pVGr7tX.png">
</p>

# Pre-Install Requirements

**General**:
- curl:
  - For Debian based distros, run: `sudo apt update && sudo apt install curl`

**Wsl2**:
- Enable systemd support:
  ```sh
  echo -e "[boot]\nsystemd=true" | sudo tee -a /etc/wsl.conf && wsl.exe -t <DistroName>
  ```
# Install

Run bootstrap help:
```sh
source <(curl -L https://raw.githubusercontent.com/simifalaye/dotfiles/main/bootstrap.sh) --help
```

Run bootstrap:

```sh
source <(curl -L https://raw.githubusercontent.com/simifalaye/dotfiles/main/bootstrap.sh) -s <ssh_email1> <ssh_keyname1> ...
./install
```

# Terminal Applications

- [atool](https://www.nongnu.org/atool/) - Archive manager
- [bat](https://github.com/sharkdp/bat) - A better cat(1)
- [bitwise](https://github.com/mellowcandle/bitwise) - Terminal bitwise calc
- [calc](https://packages.ubuntu.com/focal/calc) - Terminal calc
- [cheat](https://github.com/chubin/cheat.sh) - Cheatsheets from terminal
- [cloc](http://cloc.sourceforge.net/) - Count lines of code
- [delta](https://github.com/dandavison/delta) - Better vim diff
- [elinks](http://elinks.or.cz/) - Terminal web browser
- [exa](https://github.com/ogham/exa) - Better ls(1)
- [fd](https://github.com/sharkdp/fd) - Better find(1)
- [fzf](https://github.com/junegunn/fzf) - Terminal fuzzy finder
- [htop](https://htop.dev/) - A better top(1)
- [jq](https://stedolan.github.io/jq/) - CLI JSON processor
- [neovim](https://neovim.io/) - Best text editor!
- [ripgrep](https://github.com/BurntSushi/ripgrep) - Better grep(1)
- [rsync](https://rsync.samba.org/) - Fast, incremental file transfer
- [tig](https://github.com/jonas/tig) - Better git log
- [tmux](https://github.com/tmux/tmux) - Terminal multiplexer
- [trash-cli](https://github.com/andreafrancia/trash-cli) - Terminal trash tool
- [tree](_blank) - File tree viewer
- [zoxide](https://github.com/ajeetdsouza/zoxide) - A cd that learns
- [zsh](https://www.zsh.org/) - Best shell!
