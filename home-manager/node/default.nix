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
    nodejs
  ];

  home.file = util.linkAll (util.dot "node/dots") "${config.home.homeDirectory}";
}
