{ self, lib, modulesPath, pkgs, suites, hardware, ... }:

{
  imports = suites.goPlay ++
    [
      ./zfs.nix
      ./wireguard.nix
      ./persist.nix
      ./dns.nix
      ./yubi.nix
    ];

  time.timeZone = "America/Denver";

  environment.systemPackages = with pkgs; [
    system76-firmware
    obs-studio
    thunderbird
    tmate
  ];
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="input"
    # Rule for the Moonlander
    SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="input"
  '';

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  location = {
    latitude = 38.833881;
    longitude = -104.821365;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.usbmuxd.enable = true;

  networking.useDHCP = false;

  nix.maxJobs = lib.mkDefault 16;

  services.xserver.videoDrivers = [ "nvidia" ];

  services.fstrim.enable = true;

  # turn off laptop screen if external monitor is plugged
  services.xserver.windowManager.steam.extraSessionCommands = ''
    if ! xrandr | grep HDMI-0 | grep disconnected > /dev/null; then
      xrandr --output DP-0 --off
    fi
  '';

  services.picom = {
    backend = "glx";
    vSync = true;
  };

  security.mitigations.acceptRisk = true;

  hardware.nvidia.modesetting.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.system76.enableAll = true;

  environment.etc."xdg/qutebrowser/config.py".text = lib.mkAfter ''
    c.qt.args.append('num-raster-threads=16')
    c.qt.args.append('ignore-gpu-blacklist')
  '';
}
