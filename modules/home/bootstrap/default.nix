{
  config,
  inputs,
  lib,
  self,
  class,
  ...
}:

let
  homeManagerModule =
    with inputs.home-manager;
    {
      darwin = darwinModules.home-manager;
      nixos = nixosModules.home-manager;
    }
    ."${class}";
in

{
  imports = [
    homeManagerModule
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
      inherit self;
    };
    sharedModules = [
      "${self}/modules/home/user-profile"
    ];
    users = config.homeProfiles;
  };
}
