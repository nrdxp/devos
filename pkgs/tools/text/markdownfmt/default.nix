{ buildGoPackage, srcs }:
let src = srcs.markdownfmt; in
buildGoPackage {
  inherit src;
  inherit (src) pname version;

  vendorSha256 = "sha256-6yfsGGzdUQySyQNuB58gwbsMjJgtUhfgfPI1zYlyUQo=";

  meta = with lib; {
    description = "Like gofmt, but for Markdown.";
    homepage = "https://github.com/shurcooL/markdownfmt";
    license = licenses.mit;
    maintainers = with maintainers; [ nrdxp ];
  };
}
