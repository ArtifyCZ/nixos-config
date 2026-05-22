{
  config,
  inputs,
  lib,
  pkgs,
  pkgs-unstable,
  self,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit pkgs-unstable;
    };
    users.artify = "${self}/modules/home/user-profile";
  };
}
