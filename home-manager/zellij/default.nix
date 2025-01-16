{
  config,
  pkgs,
  ...
}: let
  util = (import ../util.nix) {config = config;};
in {
  home.packages = with pkgs; [
    unstable.zellij
  ];

  home.file = util.linkAll (util.dot "zellij/dots") "${config.home.homeDirectory}";
}
