{config, pkgs, ...}:

{
  home.stateVersion = "25.11";

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
