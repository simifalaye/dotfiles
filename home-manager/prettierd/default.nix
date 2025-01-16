{pkgs, ...}: {
  home.packages = with pkgs; [
    prettierd
  ];
}
