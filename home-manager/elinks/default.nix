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
    elinks
  ];

  home.file = util.linkAll (util.dot "elinks/dots") "${config.home.homeDirectory}";
}
