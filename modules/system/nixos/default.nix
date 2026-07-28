{ self, ... }:

{
  imports = [
    ./boot.nix
    ./overlays.nix

    "${self}/modules/home/bootstrap"
  ];
}
