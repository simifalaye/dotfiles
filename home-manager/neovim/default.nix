{
  config,
  pkgs,
  _system,
  _lib,
  ...
}: let
  util = (import ../util.nix) {config = config;};
in {
  home.packages = with pkgs; [
    luajit
    luajitPackages.luarocks
    unstable.neovim
  ];

  home.file = util.linkAll (util.dot "neovim/dots") "${config.home.homeDirectory}";
}
