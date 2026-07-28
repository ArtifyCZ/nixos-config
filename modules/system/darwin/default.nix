{ self, ... }:

{
  imports = [
    "${self}/modules/home/bootstrap"
  ];

  security.pam.services.sudo_local.touchIdAuth = true;
}
