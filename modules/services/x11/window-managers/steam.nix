{ pkgs, lib, config, ... }:

with lib;
let cfg = config.services.xserver.windowManager.steam;
in
{
  options = {
    services.xserver.windowManager.steam = {
      enable = mkEnableOption "steam";
      extraSessionCommands = mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Shell commands executed just before Steam is started.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    programs.steam.enable = true;

    services.xserver.windowManager.session = [{
      name = "steam";
      start = ''
        ${cfg.extraSessionCommands}

        # needed to ensure conflicting compositors are not running
        ${pkgs.systemd}/bin/systemctl --user stop graphical-session.target

        ${pkgs.xorg.xset}/bin/xset -dpms
        ${pkgs.xorg.xset}/bin/xset s off
        ${pkgs.steamcompmgr}/bin/steamcompmgr &
        steam -tenfoot -fulldesktopres
      '';
    }];
  };
}
