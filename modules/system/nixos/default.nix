{ self, ... }:

{
  imports = [
    ./boot.nix
    ./overlays.nix

    "${self}/modules/system/common"
    "${self}/modules/home/bootstrap"
  ];
}
