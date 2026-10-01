{
  self,
  inputs,
}:

{
  class,
  hostPlatform,
  nixpkgs,
  hostModules,
}:

let
  systemModules =
    {
      darwin = [
        "${self}/modules/home/bootstrap"
      ];
      nixos = [
        "${self}/modules/home/bootstrap"
      ];
    }
    ."${class}";
  modules = [
    { nixpkgs.hostPlatform = hostPlatform; }
  ]
  ++ nixpkgs.lib.concatLists [
    systemModules
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
