{
  config,
  inputs,
  lib,
  pkgs-unstable,
  self,
  system,
  ...
}:

let
  homeManagerModule =
    with inputs.home-manager;
    {
      "aarch64-darwin" = darwinModules.home-manager;
      "x86_64-linux" = nixosModules.home-manager;
    }
    ."${system}";
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
