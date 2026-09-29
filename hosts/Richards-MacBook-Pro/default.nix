{ pkgs, ... }:

{
  imports = [
    ./users.nix
  ];

  # Let Determinate Nix handle Nix configuration
  nix.enable = false;

  # DO NOT CHANGE!
  # This is for backwards compatibility.
  system.stateVersion = 7;

  environment.systemPackages = with pkgs; [ qemu ];

  security.pam.services.sudo_local.touchIdAuth = true;
}
