{ self, ... }:

{
  imports = [
    ./boot.nix
    ./gc.nix
    ./overlays.nix

    "${self}/modules/system/common"
    "${self}/modules/home/bootstrap"
  ];
}
