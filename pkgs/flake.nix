{
  description = "Package Sources";

  inputs = {
    retroarch.url = "github:libretro/retroarch/v1.9.0";
    retroarch.flake = false;
    any-nix-shell.url = "github:haslersn/any-nix-shell";
    any-nix-shell.flake = false;
    nix-zsh-completions.url = "github:Ma27/nix-zsh-completions/flakes";
    nix-zsh-completions.flake = false;
    redshift.url = "github:minus7/redshift/wayland";
    redshift.flake = false;
    sddm-chili.url = "github:MarianArlt/sddm-chili/0.1.5";
    sddm-chili.flake = false;
    steamcompmgr.url = "github:gamer-os/steamos-compositor-plus";
    steamcompmgr.flake = false;
    libinih.url = "github:benhoyt/inih/r53";
    libinih.flake = false;
    wii-u-gc-adapter.url = "github:ToadKing/wii-u-gc-adapter";
    wii-u-gc-adapter.flake = false;
    pure.url = "github:sindresorhus/pure";
    pure.flake = false;
    kak-powerline = { url = "github:andreyorst/powerline.kak"; flake = false; };
  };

  outputs = { self, nixpkgs, ... }: {
    overlay = final: prev: {
      inherit (self) srcs;
    };

    srcs =
      let
        inherit (nixpkgs) lib;

        mkVersion = name: input:
          let
            inputs = (builtins.fromJSON
              (builtins.readFile ./flake.lock)).nodes;

            ref =
              if lib.hasAttrByPath [ name "original" "ref" ] inputs
              then inputs.${name}.original.ref
              else "";

            version =
              let version' = builtins.match
                "[[:alpha:]]*[-._]?([0-9]+(\.[0-9]+)*)+"
                ref;
              in
              if lib.isList version'
              then lib.head version'
              else if input ? lastModifiedDate && input ? shortRev
              then "${lib.substring 0 8 input.lastModifiedDate}_${input.shortRev}"
              else null;
          in
          version;
      in
      lib.mapAttrs
        (pname: input:
          let
            version = mkVersion pname input;
          in
          input // { inherit pname; }
          // lib.optionalAttrs (! isNull version)
            {
              inherit version;
            }
        )
        (lib.filterAttrs (n: _: n != "nixpkgs")
          self.inputs);
  };
}
