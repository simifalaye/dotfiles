{pkgs, ...}: {
  imports = [
    # Base config
    ./home.nix

    ./golang
    ./neovim-Helix
    ./rust
  ];

  home.packages = with pkgs; [
    eslint_d
    nodePackages.typescript-language-server
    tailwindcss-language-server
    typescript
  ];
}
