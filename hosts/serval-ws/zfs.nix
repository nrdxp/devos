{ lib, ... }: {
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;

  services.zfs.autoSnapshot = {
    enable = true;
    frequent = 8;
    monthly = 2;
  };

  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "df2b95f1";

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "rpool/local/root";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/13A1-AD4A";
    fsType = "vfat";
  };

  fileSystems."/nix" = {
    device = "rpool/local/nix";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "rpool/safe/home";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "rpool/safe/persist";
    fsType = "zfs";
    neededForBoot = true;
  };

  # load blank root on every boot
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/local/root@blank
  '';
}
