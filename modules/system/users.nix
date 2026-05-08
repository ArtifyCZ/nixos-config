{
  self,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.artify = "${self}/modules/home";
  };

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
