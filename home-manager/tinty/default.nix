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
    tinty
  ];

  home.file = util.linkAll (util.dot "tinty/dots") "${config.home.homeDirectory}";
}
