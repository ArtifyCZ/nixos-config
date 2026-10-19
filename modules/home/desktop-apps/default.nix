{
  config,
  inputs',
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homeProfile.desktopApps;
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

  # Fake Fleet "islands": borders take the frame colour, so the seams between
  # the editor and panels look like gaps around separate surfaces.
  islands =
    { frame, island }:
    {
      "background" = frame;
      "border" = frame;
      "border.variant" = frame;
      "pane_group.border" = frame;
      "panel.focused_border" = "#00000000";
      "scrollbar.track.border" = "#00000000";
      "title_bar.background" = frame;
      "status_bar.background" = frame;
      "tab_bar.background" = frame;
      "tab.inactive_background" = frame;
      "tab.active_background" = island;
      "panel.background" = island;
      "editor.background" = island;
      "editor.gutter.background" = island;
    };
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
          inter
          jetbrains-mono
          jetbrains.clion
          jetbrains.rider
          obsidian
          openttd-jgrpp
          prismlauncher
          remmina
          signal-desktop
          tor-browser
          velotown-stoat
          vlc
          vscode
        ])

        (lib.mkIf isDarwin [
          ghostty-bin
        ])
      ];

    fonts.fontconfig.enable = isLinux;

    programs.zed-editor.enable = isLinux;

    programs.zed-editor = {
      package = pkgs.zed-editor;
      extensions = [
        "csharp"
        "fleet-themes"
        "make"
        "material-icon-theme"
        "nix"
        "rust"
        "toml"
      ];
      userSettings = {
        theme = {
          mode = "system";
          light = "Fleet Light";
          dark = "Fleet Dark";
        };
        theme_overrides = {
          "Fleet Dark" = islands {
            frame = "#090909";
            island = "#18191B";
          };
          "Fleet Light" = islands {
            frame = "#EEEFF0";
            island = "#FFFFFF";
          };
        };
        icon_theme = "Material Icon Theme";

        island_layout = {
          enabled = true;
          border = false;
          corner_radius = 12.0;
          gap = 3.0;
          pill_tabs = true;
        };

        ui_font_size = 14;
        ui_font_family = "Inter";
        buffer_font_size = 14;
        buffer_font_family = "JetBrains Mono";
        buffer_line_height = "comfortable";

        "unstable.ui_density" = "comfortable"; # roomier, Fleet-like padding
        scrollbar.show = "auto"; # scrollbars only while scrolling
        collaboration_panel.button = false; # remove status-bar clutter
        notification_panel.button = false;
        indent_guides.enabled = false; # or keep them, but they're subtle in Fleet

        current_line_highlight = "none";
        active_pane_modifiers = {
          border_size = 0;
          inactive_opacity = 1.0;
        };
        tab_bar = {
          show_nav_history_buttons = false;
          show_tab_bar_buttons = false;
        };
        tabs = {
          file_icons = true;
          git_status = true;
        };
        toolbar = {
          breadcrumbs = false;
          quick_actions = false;
        };
        title_bar = {
          show_user_picture = false;
          show_sign_in = false;
        };
        gutter = {
          folds = false;
          runnables = false;
        };
        project_panel = {
          dock = "left";
          entry_spacing = "comfortable";
          scrollbar.show = "never";
        };

        git_panel = {
          dock = "left";
          tree_view = true;
        };
        agent.dock = "right";
        vim_mode = false;
        auto_update = false;
      };
      defaultEditor = true;
    };
  };
}
