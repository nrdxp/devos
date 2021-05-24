final: prev: {
  any-nix-shell = prev.any-nix-shell.overrideAttrs
    (_:
      let src = final.srcs.any-nix-shell;
      in
      {
        inherit src;
        inherit (src) version;
      });
}
