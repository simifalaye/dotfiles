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
    zellij
  ];

  home.file = util.linkAll (util.dot "zellij/dots") "${config.home.homeDirectory}";
}
