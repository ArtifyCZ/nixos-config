{ self, ... }:

{
  imports = [
    ./boot.nix
    ./overlays.nix
    ./users.nix

    "${self}/modules/home/bootstrap"
  ];
}
