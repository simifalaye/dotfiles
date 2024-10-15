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
    ripgrep
  ];

  home.file = util.linkAll (util.dot "ripgrep/dots") "${config.home.homeDirectory}";
}
