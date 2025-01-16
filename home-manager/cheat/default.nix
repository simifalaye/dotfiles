{
  config,
  pkgs,
  ...
}: let
  util = (import ../util.nix) {config = config;};
in {
  home.packages = with pkgs; [
    cht-sh
  ];

  home.file = util.linkAll (util.dot "cheat/dots") "${config.home.homeDirectory}";
}
