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
    cheat
  ];

  home.file = util.linkAll (util.dot "cheat/dots") "${config.home.homeDirectory}";
}
