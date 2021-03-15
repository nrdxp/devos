{ lib, modulesPath, pkgs, suites, hardware, ... }:

{
  imports = suites.goPlay ++ [ hardware.common-cpu-intel ];

  time.timeZone = "America/Denver";

  environment.systemPackages = with pkgs; [
    system76-firmware
    obs-studio
    obs-v4l2sink
  ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.loader.efi.canTouchEfiVariables = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
  };

  services.usbmuxd.enable = true;

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
  };

  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/aed36f15-3b54-49fa-bd18-75ecc73ef5c9";
      keyFile = "/luks.keyfile";
      fallbackToPassword = true;
      preLVM = true;
    };
  };

  boot.initrd.secrets = { "/luks.keyfile" = ../secrets/luks.keyfile; };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/47f467dc-cf6e-4668-977d-14b344604f64";
    fsType = "xfs";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/CD10-5E00";
    fsType = "vfat";
  };

  networking.useDHCP = false;
  networking.interfaces.enp110s0.useDHCP = true;

  nix.maxJobs = lib.mkDefault 16;

  services.xserver.videoDrivers = [ "nvidia" ];

  services.fstrim.enable = true;

  services.hercules-ci-agent.settings.concurrentTasks = 16;

  services.xserver.wacom.enable = true;

  services.xserver.windowManager.steam.extraSessionCommands = ''
    if ! xrandr | grep HDMI-0 | grep disconnected > /dev/null; then
      xrandr --output DP-0 --off
    fi
  '';

  services.picom = {
    backend = "glx";
    vSync = true;
  };

  users.users.nrd.openssh.authorizedKeys.keyFiles = [
    ../secrets/serval-ws.pub
  ];

  security.mitigations.acceptRisk = true;

  hardware.nvidia.modesetting.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.system76.enableAll = true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    swapDevices = 1;
  };

  environment.etc."xdg/qutebrowser/config.py".text = lib.mkAfter ''
    c.qt.args.append('num-raster-threads=16')
    c.qt.args.append('ignore-gpu-blacklist')
  '';
}
