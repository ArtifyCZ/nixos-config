{ self, ... }:

{
  imports = [
    "${self}/modules/home/bootstrap"
  ];

  programs.zsh.enable = true;
}
