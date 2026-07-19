{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homeProfile.desktopApps;
in

{
  options.homeProfile.desktopApps = {
    enable = lib.mkEnableOption "Enable desktop (GUI) apps";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      brave
      discord
      element-desktop
      obsidian
      openttd-jgrpp
      prismlauncher
      remmina
      signal-desktop
      tor-browser
      vlc
      vscode
    ];

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
  };
}
