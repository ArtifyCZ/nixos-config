{ ... }:

{
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 14d";
  nix.gc.dates = "*-*-* *:00:00";
  nix.gc.persistent = true;
  nix.gc.randomizedDelaySec = "45min";
}
