{
  self,
  pkgs,
  ...
}:

let
  sshKeys = [
    ../../ssh-keys/Richards-MacBook-Pro-rsa.pub
  ];
in

{
  users.users.artify = {
    description = "Richard Tichy";
    openssh.authorizedKeys.keyFiles = sshKeys;
    isNormalUser = true;
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
      "video"
      "audio"
    ];
    shell = pkgs.zsh;
    linger = true;
  };

  homeProfiles.artify.imports = [
    ./home/pull-backups.nix
    ../../home
  ];
  homeProfiles.artify.homeProfile.desktopApps.enable = true;
}
