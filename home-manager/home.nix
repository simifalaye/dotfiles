# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  _inputs,
  outputs,
  _lib,
  _config,
  pkgs,
  ...
}: let
  localConfig =
    if builtins.pathExists ~/.dotfiles.local/home.nix
    then import ~/.dotfiles.local/home.nix
    else {};
in {
  # You can import other home-manager modules here
  imports = [
    ./atool
    ./bat
    ./bitwise
    ./calc
    ./cheat
    ./delta
    ./editor-tools
    ./elinks
    ./eza
    ./fd
    ./fzf
    ./gh
    ./git
    ./htop
    ./lazygit
    ./neovim
    ./node
    ./python
    ./ripgrep
    ./rsync
    ./sh
    ./tig
    ./tinty
    ./tmux
    ./trash-cli
    ./wsl
    ./zellij
    ./zoxide
    localConfig
  ];

  home = {
    username = "simifa";
    homeDirectory = "/home/simifa";
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Allow non-oss packages
      allowUnfree = true;
    };
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";

  # Configure nix
  nix = {
    package = pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  # Setup nix-specific xdg config
  xdg.configFile = {
    "shrc/zshrc.d/01-nix.zsh".text = ''
      if [ -d "$HOME"/.nix-profile/share/zsh/site-functions ]; then
        fpath=(
            "$HOME"/.nix-profile/share/zsh/site-functions
            $fpath
        )
      fi
    '';
    "shrc/bashrc.d/01-nix.bash".text = ''
      if [ -d "$HOME"/.nix-profile/share/bash-completion/completions ]; then
          for file in "$HOME"/.nix-profile/share/bash-completion/completions/*; do
              [ -f "$file" ] && . "$file"
          done
      fi
    '';
  };
}
