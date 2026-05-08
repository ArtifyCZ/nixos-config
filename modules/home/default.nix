{ pkgs, ... }:

{
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    brave
    discord
    element-desktop
    nixd
    nixfmt
    obsidian
    openttd-jgrpp
    prismlauncher
    signal-desktop
    tor-browser
    tree
    vlc
    vscode
  ];

  programs.git = {
    enable = true;
    settings = {
      init = {
        defaultBranch = "main";
      };

      user = {
        name = "Richard Tichý";
        email = "richard@tichy.io";
      };
    };
  };
}
