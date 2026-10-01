{
  inputs,
  projectLib,
  ...
}:

{
  flake.nixosConfigurations.daedalus = projectLib.mkHost {
    class = "nixos";
    hostPlatform.system = "x86_64-linux";
    nixpkgs = inputs.nixpkgs;
    hostModules = [
      ./default.nix
    ];
  };
}
