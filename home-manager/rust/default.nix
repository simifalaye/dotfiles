{
  config,
  pkgs,
  ...
}: let
  util = (import ../util.nix) {config = config;};
in {
  home.packages = with pkgs; [
    rustup
  ];

  home.file = util.linkAll (util.dot "rust/dots") "${config.home.homeDirectory}";
}
