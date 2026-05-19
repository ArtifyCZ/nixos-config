{ pkgs, pkgs-unstable, ... }:

{
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    brave
    discord
    element-desktop
    nixd
    nixfmt
    nixpkgs-review
    obsidian
    pkgs-unstable.openttd-jgrpp
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

  programs.zed-editor = {
    enable = true;
    extensions = [
      "csharp"
      "make"
      "material-icon-theme"
      "nix"
      "rust"
      "toml"
    ];
    userSettings = {
      theme.mode = "system";
      ui_font_size = 14;
      ui_font_family = ".ZedMono";
      buffer_font_size = 14;
      buffer_font_family = ".ZedMono";
      vim_mode = false;
      git_panel.dock = "left";
      git_panel.tree_view = true;
      agent.dock = "right";
      project_panel.dock = "left";
      auto_update = false;
      icon_theme = "Material Icon Theme";
    };
    defaultEditor = true;
  };
}
