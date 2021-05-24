{ lib, stdenv, srcs }:
let src = srcs.pure;
in
stdenv.mkDerivation {
  inherit src;
  inherit (src) pname version;

  buildPhase = "true";

  installPhase = ''
    mkdir -p $out/share/zsh/plugins/pure
    cp -r ./ $out/share/zsh/plugins/pure
  '';

  meta = with lib; {
    description = "Pretty, minimal and fast ZSH prompt";
    homepage = "https://github.com/sindresorhus/pure";
    maintainers = [ maintainers.nrdxp ];
    platforms = platforms.unix;
    license = licenses.mit;
    inherit version;
  };
}
