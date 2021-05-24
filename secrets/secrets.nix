let
  # set ssh public keys here for your system and user
  serval =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLrGNYsXDf4jcsAvZvc+YE1pj8yZ/FFd6Eo6amqfmKo root@serval-ws";
  allKeys = [ serval ];

  allKeysSecrets = builtins.listToAttrs (map
    (name: {
      inherit name;
      value = { publicKeys = allKeys; };
    }) [
    "aws.age"
    "cachix.age"
    "cargo.age"
    "cloudflare.age"
    "github.age"
    "gitlab.age"
    "iohk.age"
    "nrd.age"
    "wireguard.age"
    "root.age"
  ]);

in
allKeysSecrets
