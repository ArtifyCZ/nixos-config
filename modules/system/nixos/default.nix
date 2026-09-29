{ self, ... }:

{
  imports = [
    ./overlays.nix

    "${self}/modules/home/bootstrap"
  ];

  programs.zsh.enable = true;
}
