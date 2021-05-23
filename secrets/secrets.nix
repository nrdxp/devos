let
  # set ssh public keys here for your system and user
  root_serval-ws =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLrGNYsXDf4jcsAvZvc+YE1pj8yZ/FFd6Eo6amqfmKo root@serval-ws";
  nrd_serval-ws =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIML/MziS7kA8u4kzzGJDgUxI849Ydj4DH6CDj/IaWYot nrd@serval-ws";
  iohk =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDB5LMY783Srcv4pCfCjcjgug+Xq1EGTLP1AJWugGgXg tim.deherrera@iohk.io";
  allKeys = [ root_serval-ws nrd_serval-ws ];

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
