{ lib, pkgs, ... }:
let
  inherit (builtins) toFile readFile;
  inherit (lib) fileContents mkForce;

  name = "Timothy DeHerrera";
in
{

  imports = [ ../../profiles/develop ./graphical ];

  users.users.root.hashedPassword = fileContents ../../secrets/root;

  users.users.nrd.packages = with pkgs; [ pandoc ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [ nrd-logo cachix ];

  home-manager.users.nrd = {
    imports = [ ../profiles/git ../profiles/alacritty ../profiles/direnv ];

    home = {
      file = {
        ".ec2-keys".source = ../../secrets/ec2;
        ".cargo/credentials".source = ../../secrets/cargo;
        ".zshrc".text = "#";
        ".gnupg/gpg-agent.conf".text = ''
          pinentry-program ${pkgs.pinentry_curses}/bin/pinentry-curses
        '';
        ".config/cachix/cachix.dhall".source = ../../secrets/cachix.dhall;
      };
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
    };

    programs.ssh = {
      enable = true;
      hashKnownHosts = true;

      matchBlocks =
        let
          githubKey = toFile "github" (readFile ../../secrets/github);

          gitlabKey = toFile "gitlab" (readFile ../../secrets/gitlab);

          servalKey = toFile "serval-ws" (readFile ../../secrets/serval-ws);
        in
        {
          github = {
            host = "github.com";
            identityFile = githubKey;
            extraOptions = { AddKeysToAgent = "yes"; };
          };
          gitlab = {
            host = "gitlab.com";
            identityFile = gitlabKey;
            extraOptions = { AddKeysToAgent = "yes"; };
          };
          "gitlab.company" = {
            host = "gitlab.company.com";
            identityFile = gitlabKey;
            extraOptions = { AddKeysToAgent = "yes"; };
          };
          serval-ws = {
            host = "serval-ws";
            identityFile = servalKey;
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
    hashedPassword = fileContents ../../secrets/nrd;
    extraGroups = [ "wheel" "input" "networkmanager" "libvirtd" ];
  };
}
