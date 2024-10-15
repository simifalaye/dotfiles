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
    zoxide
  ];

  home.file = util.linkAll (util.dot "zoxide/dots") "${config.home.homeDirectory}";
}
