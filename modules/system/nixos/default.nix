{ self, ... }:

{
  imports = [
    ./boot.nix
    ./gc.nix
    ./overlays.nix

    "${self}/modules/home/bootstrap"
  ];

  programs.zsh.enable = true;
}
