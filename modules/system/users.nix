{
  self,
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  users.users.artify = {
    isNormalUser = true;
    description = "Richard Tichy";
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
      "video"
      "audio"
    ];
  };
}
