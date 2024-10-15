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
    alejandra
    ansible-language-server
    ansible-lint
    black
    clang-tools
    cpplint
    efm-langserver
    lua-language-server
    marksman
    nil
    nodePackages.bash-language-server
    nodePackages.vscode-json-languageserver
    prettierd
    pyright
    shellcheck
    shfmt
    stylua
    yaml-language-server
  ];

  home.file = util.linkAll (util.dot "editor-tools/dots") "${config.home.homeDirectory}";
}
