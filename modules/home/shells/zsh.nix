{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homeProfile.shells.zsh;
in

{
  options.homeProfile.shells.zsh = {
    enable = lib.mkEnableOption "Enable Zsh shell";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      oh-my-zsh.enable = true;
    };
  };
}
