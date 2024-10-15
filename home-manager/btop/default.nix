{
  _config,
  pkgs,
  _system,
  _lib,
  ...
}: {
  home.packages = with pkgs; [
    btop
  ];

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "Default";
      theme_background = false;
    };
  };
}
