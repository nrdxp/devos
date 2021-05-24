{ self, ... }: {
  age.secrets.wireguard.file = "${self}/secrets/wireguard.age";

  networking.firewall.allowedUDPPorts = [ 51820 ];

  networking.wireguard = {
    interfaces = {
      wg0 = {
        ips = [ "192.168.24.2/24" ];
        listenPort = 51820;
        privateKeyFile = "/run/secrets/wireguard";
        peers = [
          {
            allowedIPs = [ "192.168.20.21/32" ];
            publicKey = "nvKCarVUXdO0WtoDsEjTzU+bX0bwWYHJAM2Y3XhO0Ao=";
            endpoint = "8.44.153.122:51820";
            persistentKeepalive = 30;
          }
          {
            allowedIPs = [ "192.168.20.22/32" ];
            publicKey = "VcOEVp/0EG4luwL2bMmvGvlDNDbCzk7Vkazd3RRl51w=";
            endpoint = "8.44.153.122:1024";
            persistentKeepalive = 30;
          }
        ];
      };
    };
  };
}
