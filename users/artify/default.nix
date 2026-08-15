{ pkgs, lib, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  sshKeys = builtins.readDir ./ssh-keys;
in

{
  config = lib.mkMerge [
    {
      users.users.artify = lib.mkMerge [
        {
          description = "Richard Tichy";
          openssh.authorizedKeys.keys = (builtins.attrValues sshKeys);
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
