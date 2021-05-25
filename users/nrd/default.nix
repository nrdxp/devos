{ self, lib, pkgs, ... }:
let
  inherit (builtins) toFile readFile;
  inherit (lib) fileContents mkForce;

  name = "Timothy DeHerrera";
in
{

  imports = [
    ../../profiles/develop
    ./graphical
    # foo bar
    (lib.mkAliasOptionModule [ "nrd" ] [ "home-manager" "users" "nrd" ])
  ];

  age.secrets = {
    root.file = "${self}/secrets/root.age";
    nrd.file = "${self}/secrets/nrd.age";
    github.file = "${self}/secrets/github.age";
    github.owner = "nrd";
    gitlab.file = "${self}/secrets/gitlab.age";
    gitlab.owner = "nrd";
    iohk.file = "${self}/secrets/iohk.age";
    iohk.owner = "nrd";
    aws.file = "${self}/secrets/aws.age";
    aws.owner = "nrd";
    cargo.file = "${self}/secrets/cargo.age";
    cargo.owner = "nrd";
    cachix.file = "${self}/secrets/cachix.age";
    cachix.owner = "nrd";
  };

  users.users.nrd.openssh.authorizedKeys.keyFiles = [ ./yubi.pub ];

  users.users.root.openssh.authorizedKeys.keyFiles = [ ./yubi.pub ];

  users.users.root.passwordFile = "/run/secrets/root";

  users.users.nrd.packages = with pkgs; [ pandoc ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.adb.enable = true;

  environment.systemPackages = with pkgs; [ nrd-logo cachix ];

  nrd = { lib, ... }: {
    imports = [ ../profiles/git ../profiles/alacritty ../profiles/direnv ];

    home = {
      activation.myActivationAction =
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          mkdir -p ~/{.aws,cargo,.ssh,.config/cachix}
          ln -sf /run/secrets/aws ~/.aws/credentials
          ln -sf /run/secrets/cargo ~/.cargo/credentials
          ln -sf /run/secrets/cachix ~/.config/cachix/cachix.dhall
          ln -sf /run/secrets/iohk ~/.ssh/iohk
        '';

      file = {
        ".ssh/config".text = lib.mkBefore ''
          Include config.d/*.conf
        '';
        ".ssh/config.d/iohk.conf".source = ./iohk.conf;
        ".ssh/config.d/ringer.conf".source = ./ringer.conf;
        ".zshrc".text = "#";
        ".gnupg/gpg-agent.conf".text = ''
          pinentry-program ${pkgs.pinentry_curses}/bin/pinentry-curses
        '';
      };
    };

    programs.go = {
      enable = true;
      goPath = "go";
    };

    programs.mpv = {
      enable = true;
      config = {
        ytdl-format = "bestvideo[height<=?1080]+bestaudio/best";
        hwdec = "auto";
        vo = "gpu";
      };
    };

    programs.git = {
      userName = name;
      userEmail = "tim.deh@pm.me";
      signing = {
        key = "8985725DB5B0C122";
        signByDefault = true;
      };
      includes = [{
        condition = "gitdir:~/work/";
        path = ./work.inc;
      }];
    };

    programs.ssh = {
      enable = true;
      hashKnownHosts = true;

      matchBlocks = {
        github = {
          host = "github.com";
          identityFile = "/run/secrets/github";
          extraOptions = { AddKeysToAgent = "yes"; };
        };
        gitlab = {
          host = "gitlab.com";
          identityFile = "/run/secrets/gitlab";
          extraOptions = { AddKeysToAgent = "yes"; };
        };
        "gitlab.company" = {
          host = "gitlab.company.com";
          identityFile = "/run/secrets/gitlab";
          extraOptions = { AddKeysToAgent = "yes"; };
        };
      };
    };
  };

  services.postgresql = {
    ensureDatabases = [ "nrd" ];
    ensureUsers = [{
      name = "nrd";
      ensurePermissions = { "DATABASE nrd" = "ALL PRIVILEGES"; };
    }];
  };

  users.groups.media.members = [ "nrd" ];

  users.users.nrd = {
    uid = 1000;
    description = name;
    isNormalUser = true;
    passwordFile = "/run/secrets/nrd";
    extraGroups = [ "wheel" "input" "networkmanager" "libvirtd" "adbusers" ];
  };
}
