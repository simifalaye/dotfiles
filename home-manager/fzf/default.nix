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
    fzf
  ];

  home.file = util.linkAll (util.dot "fzf/dots") "${config.home.homeDirectory}";
}
