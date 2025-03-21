{
  config,
  pkgs,
  ...
}: let
  util = (import ../util.nix) {config = config;};
in {
  home.packages = with pkgs; [
    nodePackages.bash-language-server
    shellcheck
    shfmt
  ];

  home.file = util.linkAll (util.dot "sh/dots") "${config.home.homeDirectory}";
}
