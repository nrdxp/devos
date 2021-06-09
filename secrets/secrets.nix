let
  # set ssh public keys here for your system and user
  serval =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLrGNYsXDf4jcsAvZvc+YE1pj8yZ/FFd6Eo6amqfmKo root@serval-ws";
  yubi = "age1yubikey1qgrwptu4eqh0dhy8dwnc963xhrm9qnlcg5qcygtquve5p8l5x42pzshf5q7";
  allKeys = [ serval yubi ];

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
