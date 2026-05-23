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
      nixd
      nixfmt
      nixpkgs-review
      tree
    ];
  };
}
