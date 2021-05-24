hook -group lint global WinSetOption filetype=cue %{
  set buffer lintcmd 'cue vet'
  set buffer formatcmd "/etc/xdg/kak/autoload/lint/cue.sh"
  set buffer disabled_hooks "tabconv"
  set buffer indentwidth 0

  hook buffer BufWritePre .* %{
    format
    lint
  }
}
