{
  description = "Richard's Nix configurations";

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
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nix-darwin,
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
      darwinConfigurations."Richards-MacBook-Pro" = mkSystem {
        system = "aarch64-darwin";
        hostModules = [
          "${self}/hosts/Richards-MacBook-Pro"
        ];
        userModules = [
          "${self}/users/artify"
        ];
      };

      nixosConfigurations.artifydesktop = mkSystem {
        system = "x86_64-linux";
        hostModules = [
          "${self}/hosts/artifydesktop"
        ];
        userModules = [
          "${self}/users/artify"
        ];
      };

      nixosConfigurations.daedalus = mkSystem {
        system = "x86_64-linux";
        hostModules = [
          "${self}/hosts/daedalus"
        ];
        userModules = [
          "${self}/users/artify"
        ];
      };
    };
}
