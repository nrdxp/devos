{ pkgs, ... }: {
  services.pcscd.enable = true;

  services.udev.packages = with pkgs; [ yubikey-personalization ];
  environment.systemPackages = with pkgs; [
    yubikey-personalization
    yubico-pam
    yubikey-manager
  ];

  security.pam.yubico = {
    enable = true;
    debug = false;
    mode = "challenge-response";
  };
}
