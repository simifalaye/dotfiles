{
  _config,
  pkgs,
  _system,
  _lib,
  ...
}: {
  home.packages = with pkgs; [
    delta
  ];
}
