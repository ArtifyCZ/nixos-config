{
  self,
  inputs,
}:

{
  class,
  hostPlatform,
  nixpkgs,
  userModules,
  hostModules,
}:

let
  systemModules =
    {
      darwin = [
        "${self}/modules/system/darwin"
      ];
      nixos = [
        "${self}/modules/system/nixos"
      ];
    }
    ."${class}";
  modules = [
    { nixpkgs.hostPlatform = hostPlatform; }
  ]
  ++ nixpkgs.lib.concatLists [
    systemModules
    userModules
    hostModules
  ];

  specialArgs = {
    inherit
      inputs
      self
      class
      hostPlatform
      ;
  };
  builder =
    {
      darwin = inputs.nix-darwin.lib.darwinSystem;
      nixos = nixpkgs.lib.nixosSystem;
    }
    ."${class}";
in

builder {
  system = hostPlatform.system;
  inherit
    modules
    specialArgs
    ;
}
