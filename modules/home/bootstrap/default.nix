{
  config,
  inputs,
  lib,
  pkgs-unstable,
  self,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.homeProfiles = lib.mkOption {
    default = { };
    description = "A module for each user's profile";
    type = lib.types.attrsOf lib.types.unspecified;
  };

  config.home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit
        self
        pkgs-unstable
        ;
    };
    sharedModules = [
      "${self}/modules/home/user-profile"
    ];
    users = config.homeProfiles;
  };
}
