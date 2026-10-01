{
  inputs,
  projectLib,
  ...
}:

{
  flake.darwinConfigurations."Richards-MacBook-Pro" = projectLib.mkHost {
    class = "darwin";
    hostPlatform.system = "aarch64-darwin";
    nixpkgs = inputs.nixpkgs;
    hostModules = [
      ./default.nix
    ];
  };
}
