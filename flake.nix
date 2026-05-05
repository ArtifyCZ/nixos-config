{
  description = "My Encrypted NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgsFork.url = "github:artifycz/nixpkgs/master";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgsFork, disko, ... }@inputs: {
    nixosConfigurations.artifydesktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        disko.nixosModules.disko
        ./disko-config.nix
        ./configuration.nix
        ./hardware-configuration.nix
      ];
    };
  };
}
