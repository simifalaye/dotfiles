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
    calc
  ];

  home.file = util.linkAll (util.dot "calc/dots") "${config.home.homeDirectory}";
}
