final: prev: {
  kakoune = prev.kakoune.override {
    plugins = with final.kakounePlugins; [
      kak-fzf
      kak-buffers
      (kak-powerline.overrideAttrs
        (self:
          let src = final.srcs.kak-powerline;
          in { inherit src; inherit (src) version; })
      )
      kak-vertical-selection
    ];
  };

  # wrapper to specify config dir
  kakoune-config = prev.writeShellScriptBin "k" ''
    KAKOUNE_CONFIG_DIR=/etc/xdg/kak exec ${final.kakoune}/bin/kak "$@"
  '';
}
