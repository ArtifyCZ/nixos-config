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
  systemModules =
    {
      "aarch64-darwin" = [
        "${self}/modules/system/darwin"
      ];
      "x86_64-linux" = [
        "${self}/modules/system/nixos"
      ];
    }
    ."${system}";
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
      system
      ;
  };
  builder =
    {
      "aarch64-darwin" = inputs.nix-darwin.lib.darwinSystem;
      "x86_64-linux" = nixpkgs.lib.nixosSystem;
    }
    ."${system}";
in

builder {
  inherit
    system
    modules
    specialArgs
    ;
}
