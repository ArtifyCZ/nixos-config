{
  description = "Richard's Nix configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
      nix-darwin,
      ...
    }@inputs:
    let
      mkHost = import ./lib/mkHost.nix {
        inherit inputs self;
      };
    in

    {
      darwinConfigurations."Richards-MacBook-Pro" = mkHost {
        class = "darwin";
        hostPlatform.system = "aarch64-darwin";
        inherit nixpkgs;
        hostModules = [
          "${self}/hosts/Richards-MacBook-Pro"
        ];
        userModules = [
          "${self}/users/artify"
        ];
      };

      nixosConfigurations.artifydesktop = mkHost {
        class = "nixos";
        hostPlatform.system = "x86_64-linux";
        inherit nixpkgs;
        hostModules = [
          "${self}/hosts/artifydesktop"
        ];
        userModules = [
          "${self}/users/artify"
        ];
      };

      nixosConfigurations.daedalus = mkHost {
        class = "nixos";
        hostPlatform.system = "x86_64-linux";
        inherit nixpkgs;
        hostModules = [
          "${self}/hosts/daedalus"
        ];
        userModules = [
          "${self}/users/artify"
        ];
      };
    };
}
