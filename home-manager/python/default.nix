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
    python3
  ];

  home.file = util.linkAll (util.dot "python/dots") "${config.home.homeDirectory}";
}
