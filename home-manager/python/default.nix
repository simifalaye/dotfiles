{
  config,
  pkgs,
  ...
}: let
  util = (import ../util.nix) {config = config;};
in {
  home.packages = with pkgs; [
    black
    pyright
    python3
  ];

  home.file = util.linkAll (util.dot "python/dots") "${config.home.homeDirectory}";
}
