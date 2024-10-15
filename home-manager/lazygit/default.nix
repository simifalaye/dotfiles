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
    lazygit
  ];

  home.file = util.linkAll (util.dot "lazygit/dots") "${config.home.homeDirectory}";
}
