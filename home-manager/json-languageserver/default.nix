{pkgs, ...}: {
  home.packages = with pkgs; [
    nodePackages.vscode-json-languageserver
  ];
}
