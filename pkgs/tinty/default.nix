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
  sha256 =
    if pkgs.stdenv.isDarwin
    then "571387b75705a9ec906ea92bc119deeaba86a6531ac6263cf8ab10e73a5eb829"
    else if pkgs.stdenv.isx86_64
    then "9ca23d8f5325238985be2ffeed9a3c6a45e270ab1e4d30648f848eb656d30e4f"
    else if pkgs.stdenv.isAarch64
    then "649407a3e84b8957670d9c38bc15ffb8a4687e611289d6b5f43f3ed28d860db9"
    else if pkgs.stdenv.isi686
    then "165654ab89da4940ebd19a7cf73c023b32de5d3f271d189ed06b89e9fe4c60ea"
    else throw "Unsupported architecture";

  url = "https://github.com/tinted-theming/tinty/releases/download/v0.23.0/tinty-${arch}.tar.gz";
in
  pkgs.stdenv.mkDerivation {
    pname = "tinty";
    version = "0.23.0";

    src = pkgs.fetchurl {
      url = url;
      sha256 = sha256;
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
