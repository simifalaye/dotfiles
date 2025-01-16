{
  config,
  pkgs,
  ...
}: let
  util = (import ../util.nix) {config = config;};
in {
  home.packages = with pkgs; [
    go
    gopls
    golangci-lint-langserver
    golines
  ];

  home.file = util.linkAll (util.dot "golang/dots") "${config.home.homeDirectory}";
}
