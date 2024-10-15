# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  _inputs,
  outputs,
  _lib,
  _config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    ./atool
    ./bat
    ./bitwise
    ./btop
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
    ./zellij
    ./zoxide
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
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
}
