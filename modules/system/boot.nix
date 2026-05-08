{ pkgs, ... }:

{
  # Disable systemd-boot
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = false;
    theme = pkgs.sleek-grub-theme.override {
      withStyle = "bigSur";
      withBanner = "";
    };
  };

  boot.plymouth = {
    enable = true;
    theme = "circuit";
    themePackages = with pkgs; [
      (adi1090x-plymouth-themes.override {
        selected_themes = [ "circuit" ];
      })
    ];
  };

  # Enable "Silent Boot"
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    "quiet"
    "splash"
    "udev.log_level=3"
    "systemd.show_status=auto"
  ];
}
