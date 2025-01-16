{pkgs, ...}: {
  home.packages = with pkgs; [
    gh
    gh-dash
  ];
}
