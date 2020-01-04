{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ thunderbird fdm ];

  systemd.services.protonmail-bridge = {
    enable = true;
    serviceConfig = {
      ExecStart = ''
        ${pkgs.protonmail-bridge}/bin/protonmail-bridge -c
      '';
    };
  };
}
