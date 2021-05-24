hook -group lsp global WinSetOption filetype=rust %{
# racer.kak conflicts with rls completion; keep before lsp-enable
  racer-disable-autocomplete

  set buffer indentwidth 4
  set buffer tabstop 4

  lsp-enable-window

  set buffer lsp_server_configuration rust.clippy_preference="on"
}
