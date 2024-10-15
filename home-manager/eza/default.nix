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
    eza
  ];

  home.file = util.linkAll (util.dot "eza/dots") "${config.home.homeDirectory}";
}
