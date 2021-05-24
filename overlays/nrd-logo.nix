final: prev: {
  nrd-logo = prev.stdenv.mkDerivation {
    name = "nrdxp-logo";
    src = ../users/nrd/logo.png;
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/share/sddm/faces
      cp $src $out/share/sddm/faces/nrd.face.icon
    '';
  };
}
