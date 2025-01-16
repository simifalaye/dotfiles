{
  config,
  pkgs,
  ...
}: let
  util = (import ../util.nix) {config = config;};
in {
  home.packages = with pkgs; [
    direnv
  ];

  home.file = util.linkAll (util.dot "direnv/dots") "${config.home.homeDirectory}";
}
