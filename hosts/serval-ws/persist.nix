{
  fileSystems."/etc/ssh" = {
    depends = [ "/persist" ];
    neededForBoot = true;
  };

  environment.persistence."/persist" = {
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/hercules-ci-agent"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"
    ];

    files = [ "/etc/machine-id" ];
  };
}
