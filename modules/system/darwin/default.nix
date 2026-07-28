{ self, ... }:

{
  imports = [
    "${self}/modules/system/common"
    "${self}/modules/home/bootstrap"
  ];

  security.pam.services.sudo_local.touchIdAuth = true;
}
