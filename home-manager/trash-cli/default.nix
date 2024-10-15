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
    trash-cli
  ];

  home.file = util.linkAll (util.dot "trash-cli/dots") "${config.home.homeDirectory}";
}
