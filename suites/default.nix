{ lib }:
let
  inherit (lib) dev;

  profiles = dev.os.mkProfileAttrs (toString ../profiles);
  users = dev.os.mkProfileAttrs (toString ../users);

  allProfiles =
    let defaults = lib.collect (x: x ? default) profiles;
    in map (x: x.default) defaults;

  allUsers =
    let defaults = lib.collect (x: x ? default) users;
    in map (x: x.default) defaults;

  suites = with profiles; rec {
    work = [ develop virt users.nrd ci-agent ssh ];

    graphics = work ++ [ graphical ];

    mobile = graphics ++ [ laptop ];

    play = graphics ++ [
      graphical.games
      network.torrent
      misc.disable-mitigations
    ];

    goPlay = play ++ [ laptop ];
  };
in
lib.mapAttrs (_: v: dev.os.profileMap v) suites // {
  inherit allProfiles allUsers;
}
