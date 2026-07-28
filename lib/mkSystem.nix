{
  self,
  nixpkgs,
  nixpkgs-unstable,
  inputs,
}:

{
  system,
  userModules,
  hostModules,
}:

let
  systemModules = [
    "${self}/modules/system/nixos"
  ];
  modules = nixpkgs.lib.concatLists [
    systemModules
    userModules
    hostModules
  ];

  pkgs-unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
  specialArgs = {
    inherit
      inputs
      self
      pkgs-unstable
      ;
  };
in

nixpkgs.lib.nixosSystem {
  inherit
    system
    modules
    specialArgs
    ;
}
