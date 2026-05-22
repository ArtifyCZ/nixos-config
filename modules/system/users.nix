{
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

  homeProfiles.artify = {
    enable = true;
  };
}
