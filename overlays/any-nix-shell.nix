final: prev: {
  any-nix-shell = prev.any-nix-shell.overrideAttrs
    (_:
      let src = prev.srcs.any-nix-shell;
      in
      {
        inherit src;
        inherit (src) version;
      });
}
