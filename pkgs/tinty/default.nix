{pkgs ? import <nixpkgs> {}}: let
  arch =
    if pkgs.stdenv.isDarwin
    then "universal-apple-darwin"
    else if pkgs.stdenv.isx86_64
    then "x86_64-unknown-linux-gnu"
    else if pkgs.stdenv.isAarch64
    then "aarch64-unknown-linux-gnu"
    else if pkgs.stdenv.isi686
    then "i686-unknown-linux-gnu"
    else throw "Unsupported architecture";
  url = "https://github.com/tinted-theming/tinty/releases/download/v0.22.0/tinty-${arch}.tar.gz";
in
  pkgs.stdenv.mkDerivation {
    pname = "tinty";
    version = "0.22.0";

    src = pkgs.fetchurl {
      url = url;
      sha256 = "590e4ca346f8eb87e068d2d11a7e9bfb0493e2361991a8d6c4eea79ac97ad575";
    };

    unpackPhase = ''
      mkdir source
      tar -xzf $src -C source
    '';

    installPhase = ''
      # Install bin
      mkdir -p $out/bin
      cp source/tinty $out/bin
    '';

    meta = {
      description = "A Base16 and Base24 color scheme manager";
      homepage = "https://github.com/tinted-theming/tinty";
      license = pkgs.lib.licenses.mit;
      maintainers = [];
    };
  }
