{ pkgs, ... }: {
  imports = [ ../python ../haskell ];

  environment.systemPackages = with pkgs; [
    clang-tools
    editorconfig-core-c
    kak-lsp
    kakoune-config
    kakoune
    nixfmt
    python3Packages.python-language-server
    nix-linter
    dhall
    dhall-lsp-server
    haskellPackages.haskell-language-server
  ];

  environment.etc = {
    "xdg/kak-lsp/kak-lsp.toml".source = ./kak-lsp.toml;
    "xdg/kak/kakrc".source = ./kakrc;
    "xdg/kak/autoload/plugins-config".source = ./plugins;
    "xdg/kak/autoload/lint".source = ./lint;
    "xdg/kak/autoload/lsp".source = ./lsp;
    "xdg/kak/autoload/default".source =
      "${pkgs.kakoune}/share/kak/rc";
    "xdg/kak/autoload/plugins".source =
      "${pkgs.kakoune}/share/kak/autoload/plugins";
  };
}
