{ lib, stdenv, patchelf, gcc, glib, nspr, nss, unzip, ... }:
let
  inherit (builtins) fetchurl;
  inherit (stdenv) mkDerivation;
  mkrpath = p: "${lib.makeSearchPathOutput "lib" "lib64" p}:${lib.makeLibraryPath p}";
in
mkDerivation rec {
  name = "${pname}-${version}";
  pname = "widevine-cdm";
  version = "4.10.2209.1";

  src = fetchurl {
    url = "https://dl.google.com/${pname}/${version}-linux-x64.zip";
    sha256 = "sha256:1mnbxkazjyl3xgvpna9p9qiiyf08j4prdxry51wk8jj5ns6c2zcc";
  };

  unpackCmd = "unzip -d ./src $curSrc";

  nativeBuildInputs = [ unzip ];

  PATCH_RPATH = mkrpath [ gcc.cc glib nspr nss ];

  patchPhase = ''
    patchelf --set-rpath "$PATCH_RPATH" libwidevinecdm.so
  '';

  installPhase = ''
    install -vD libwidevinecdm.so \
      "$out/lib/libwidevinecdm.so"
  '';

  meta.platforms = [ "x86_64-linux" ];
}
