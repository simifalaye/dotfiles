{
  config,
  pkgs,
  ...
}: let
  util = (import ../util.nix) {config = config;};
in {
  home.packages = with pkgs; [
    bat
  ];

  home.file = util.linkAll (util.dot "bat/dots") "${config.home.homeDirectory}";
}
