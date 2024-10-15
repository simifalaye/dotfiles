{
  config,
  _pkgs,
  _system,
  _lib,
  ...
}: let
  util = (import ../util.nix) {config = config;};
in {
  home.file = util.linkAll (util.dot "git/dots") "${config.home.homeDirectory}";
}
