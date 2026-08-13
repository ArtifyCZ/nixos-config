{ pkgs, lib, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in

{
  config = lib.mkMerge [
    {
      users.users.artify = lib.mkMerge [
        {
          description = "Richard Tichy";
        }
        (lib.mkIf isDarwin {
          home = "/Users/artify";
        })
        (lib.mkIf isLinux {
          isNormalUser = true;
          extraGroups = [
            "docker"
            "networkmanager"
            "wheel"
            "video"
            "audio"
          ];
          shell = pkgs.zsh;
        })
      ];

      homeProfiles.artify.imports = [ ./home ];
    }
  ];
}
