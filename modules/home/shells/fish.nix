{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homeProfile.shells.fish;
in

{
  options.homeProfile.shells.fish = {
    enable = lib.mkEnableOption "Enable fish shell";
  };

  config = lib.mkIf cfg.enable {
    programs.fish.enable = true;
    programs.fish.plugins = with pkgs.fishPlugins; [
      {
        name = "grc";
        src = grc.src;
      }
    ];

    home.packages = with pkgs; [
      grc
    ];
  };
}
