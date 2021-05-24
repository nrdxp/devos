{ stdenv
, libudev
, SDL
, SDL_image
, lib
, libXdamage
, libXcomposite
, libXrender
, libXext
, libXxf86vm
, pkgconfig
, autoreconfHook
, gnumake
, srcs
}:
let src = srcs.steamcompmgr;
in
stdenv.mkDerivation {
  inherit src;
  inherit (src) pname version;

  buildInputs = [
    libudev
    SDL
    SDL_image
    libXdamage
    libXcomposite
    libXrender
    libXext
    libXxf86vm
    pkgconfig
    autoreconfHook
    gnumake
  ];

  meta = with lib; {
    description = "SteamOS Compositor";
    homepage = "https://github.com/steamos-compositor-plus";
    maintainers = [ maintainers.nrdxp ];
    license = licenses.bsd2;
    platforms = platforms.linux;
    inherit version;
  };
}
