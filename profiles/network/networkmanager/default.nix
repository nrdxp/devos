{ lib, ... }: {
  networking.networkmanager = {
    enable = true;
    dns = lib.mkForce "none";
    extraConfig = ''
      [main]
      systemd-resolved=false
    '';
    wifi.backend = "iwd";
  };

  networking.nameservers =
    [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];

  services.resolved = {
    enable = true;
    dnssec = "false";
    fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };
}
