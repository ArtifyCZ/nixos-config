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

  options.homeProfiles = lib.mkOption {
    default = { };
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "Activate this user profile";
        };
      }
    );
  };

  config.home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit pkgs-unstable;
    };
    users =
      let
        activeProfiles = lib.filterAttrs (name: value: value.enable) config.homeProfiles;
        mkHomeModule = username: homeProfile: {
          imports = [
            "${self}/modules/home/user-profile"
          ];
          config.homeProfile = homeProfile;
        };
      in
      lib.mapAttrs mkHomeModule activeProfiles;
  };
}
