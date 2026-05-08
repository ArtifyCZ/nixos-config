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
    users.artify = "${self}/home-manager";
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
    packages = with pkgs; [
      brave
      discord
      element-desktop
      nixd
      obsidian
      openttd-jgrpp
      prismlauncher
      signal-desktop
      tor-browser
      tree
      vlc
      vscode
    ];
  };
}
