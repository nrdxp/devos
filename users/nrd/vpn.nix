{ config, pkgs, ... }: {

  imports = [ ../../profiles/network/networkmanager ];

  environment.systemPackages = with pkgs; [ protonvpn-cli ];

  systemd.services.protonvpn = with pkgs; {
    enable = true;
    after = [ "network-online.target" ];
    description = "Auto-Connect to Fastest ProtonVPN Server";
    wantedBy = [ "multi-user.target" ];

    path = [ which iproute procps coreutils ];

    environment = {
      PVPN_WAIT = "300";
      PVPN_DEBUG = "1";
    };

    serviceConfig =
      let systemd = config.systemd.package;
      in
      {
        Type = "forking";
        ExecStart = "${protonvpn-cli}/bin/protonvpn c -f";
        ExecStop = "${protonvpn-cli}/bin/protonvpn d";
        ExecStartPost = writeShellScript "vpn-resolved" ''
          nameserver=$(tail -1 /etc/resolv.conf | cut -d ' ' -f 2)
          ${systemd}/bin/resolvectl dnsovertls proton0 no
          ${systemd}/bin/resolvectl dns proton0 $nameserver
          ${systemd}/bin/resolvectl domain proton0 '~.'
        '';
      };
  };
}
