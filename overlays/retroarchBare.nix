final: prev: {
  retroarchBare = prev.retroarchBare.overrideAttrs (o: {
    inherit (final.srcs.retroarch) version;

    src = final.srcs.retroarch;

    # fix darwin builds
    nativeBuildInputs =
      if ! prev.stdenv.isLinux then
        prev.lib.filter
          (drv: ! prev.lib.hasPrefix "wayland" drv.name)
          o.nativeBuildInputs
      else
        o.nativeBuildInputs;
  });
}
