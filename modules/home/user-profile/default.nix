{
  pkgs,
  self,
  ...
}:

{
  imports = [
    ./git.nix

    "${self}/modules/home/desktop-apps"
    "${self}/modules/home/shells"
  ];

  config = {
    home.stateVersion = "25.11";

    home.packages = with pkgs; [
      cdrkit
      gnumake
      nixd
      libllvm
      nixfmt
      nixpkgs-review
      pkgsCross.i686-embedded.buildPackages.gcc
      tree
    ];
  };
}
