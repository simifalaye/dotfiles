{
  config,
  pkgs,
  ...
}: let
  util = (import ../util.nix) {config = config;};
in {
  home.packages = with pkgs;
    if util.isWSL
    then [
      wsl-open
      wslu
    ]
    else [];
}
