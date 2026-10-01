{
  description = "Richard's Nix configurations";

  inputs = {
    # keep-sorted start block=yes
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # keep-sorted end
  };

  outputs =
    {
      self,
      flake-parts,
      nixpkgs,
      nix-darwin,
      ...
    }@inputs:
    let
      projectLib.mkHost = import ./lib/mkHost.nix {
        inherit inputs self;
      };
    in

    flake-parts.lib.mkFlake
      {
        inherit inputs;
        specialArgs = {
          inherit
            projectLib
            ;
        };
      }
      {
        systems = [
          "aarch64-darwin"
          "x86_64-linux"
        ];

        imports = [
          inputs.treefmt-nix.flakeModule

          # keep-sorted start case=no
          ./hosts/artifydesktop/host.nix
          ./hosts/daedalus/host.nix
          ./hosts/Richards-MacBook-Pro/host.nix
          # keep-sorted end
        ];

        perSystem = _: {
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              keep-sorted.enable = true;
              nixfmt.enable = true;
            };
          };
        };
      };
}
