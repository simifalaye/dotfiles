{
  config,
  pkgs,
  _system,
  _lib,
  ...
}: let
  util = (import ../util.nix) {config = config;};
in {
  home.packages = with pkgs; [
    cargo
    rust-analyzer
    rustfmt
  ];

  # home.file = util.linkAll (util.dot "rust/dots") "${config.home.homeDirectory}";
}
