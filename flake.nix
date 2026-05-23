{
  description = "My Encrypted NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }@inputs:
    let
      mkSystem = import ./lib/mkSystem.nix {
        inherit
          inputs
          self
          nixpkgs
          nixpkgs-unstable
          ;
      };
    in

    {
      nixosConfigurations.artifydesktop = mkSystem {
        system = "x86_64-linux";
        hostModules = [
          "${self}/hosts/artifydesktop"
        ];
        userModules = [
          "${self}/users/artify"
        ];
      };
    };
}
