final: prev: {
  # with sway/wayland support
  redshift = (prev.redshift.overrideAttrs (_:
    let
      src = prev.srcs.redshift;
    in
    {
      inherit src;
      inherit (src) version;
    })).override { withAppIndicator = prev.stdenv.isLinux; };
}
