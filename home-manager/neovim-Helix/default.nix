{config, ...}: let
  util = (import ../util.nix) {config = config;};
in {
  home.file = util.linkAll (util.dot "neovim-Helix/dots") "${config.home.homeDirectory}";
}
