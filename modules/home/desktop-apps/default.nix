{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homeProfile.desktopApps;
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in

{
  options.homeProfile.desktopApps = {
    enable = lib.mkEnableOption "Enable desktop (GUI) apps";
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      lib.mkMerge [
        (lib.mkIf isLinux [
          brave
          cinny-desktop
          discord
          element-desktop
          heroic
          jetbrains.rider
          obsidian
          openttd-jgrpp
          prismlauncher
          remmina
          signal-desktop
          tor-browser
          vlc
          vscode
        ])

        (lib.mkIf isDarwin [
          ghostty-bin
        ])
      ];

    programs.zed-editor.enable = isLinux;

    programs.zed-editor = {
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
