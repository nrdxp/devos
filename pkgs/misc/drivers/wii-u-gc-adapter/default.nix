{ lib, stdenv, pkgconfig, libudev, libusb, srcs, ... }:

let src = srcs.wii-u-gc-adapter; in
stdenv.mkDerivation {
  inherit src;
  inherit (src) pname version;

  buildInputs = [ pkgconfig libudev libusb ];

  installPhase = ''
    mkdir -p $out/bin
    install wii-u-gc-adapter $out/bin
  '';

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "Tool for using the Wii U GameCube Adapter on Linux";
    homepage = "https://github.com/ToadKing/wii-u-gc-adapter";
    maintainers = [ maintainers.nrdxp ];
    license = licenses.mit;
    platforms = platforms.linux;
    inherit version;
  };
}
