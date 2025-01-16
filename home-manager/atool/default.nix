{pkgs, ...}: {
  home.packages = with pkgs; [
    atool
  ];
}
