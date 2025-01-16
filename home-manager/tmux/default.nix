{
  config,
  pkgs,
  ...
}: let
  util = (import ../util.nix) {config = config;};
in {
  home.packages = with pkgs; [
    tmux
  ];

  home.file = util.linkAll (util.dot "tmux/dots") "${config.home.homeDirectory}";
}
