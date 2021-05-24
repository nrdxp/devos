{ pkgs, ... }: {
  services.pcscd.enable = true;

  services.udev.packages = with pkgs; [ yubikey-personalization ];
  environment.systemPackages = with pkgs; [ yubikey-personalization ];
}
