{
  config,
  pkgs,
  ...
}: let
  util = (import ../util.nix) {config = config;};
in {
  home.packages = with pkgs; [
    lua-language-server
    luajitPackages.luacheck
    stylua
  ];

  home.file = util.linkAll (util.dot "lua/dots") "${config.home.homeDirectory}";
}
