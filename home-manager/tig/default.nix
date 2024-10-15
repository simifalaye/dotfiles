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
    tig
  ];

  home.file = util.linkAll (util.dot "tig/dots") "${config.home.homeDirectory}";
}
