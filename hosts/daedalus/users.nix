{
  self,
  pkgs,
  ...
}:

let
  sshKeys = [
    ../../ssh-keys/artifydesktop-ed25519.pub
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
  };

  homeProfiles.artify.imports = [ ../../home ];
}
