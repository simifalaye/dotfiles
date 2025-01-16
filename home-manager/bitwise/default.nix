{pkgs, ...}: {
  home.packages = with pkgs; [
    bitwise
  ];
}
