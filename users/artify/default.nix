{ pkgs, lib, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  sshKeys = [
    ./ssh-keys/artifydesktop-ed25519.pub
    ./ssh-keys/Richards-MacBook-Pro-rsa.pub
  ];
in

{
  config = lib.mkMerge [
    {
      users.users.artify = lib.mkMerge [
        {
          description = "Richard Tichy";
          openssh.authorizedKeys.keyFiles = sshKeys;
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
