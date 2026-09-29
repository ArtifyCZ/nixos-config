{ self, ... }:

{
  imports = [
    ./gc.nix
    ./overlays.nix

    "${self}/modules/home/bootstrap"
  ];

  programs.zsh.enable = true;
}
