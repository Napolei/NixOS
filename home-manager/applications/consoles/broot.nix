# broot shell function `br` (cd into the selected directory on quit)
# https://dystroy.org/broot/install-br/
# Settings live in ~/.config/broot/conf.hjson, created by broot on first start:
# https://dystroy.org/broot/conf_file/

{ ... }:

{
  programs.bash.initExtra = ''
    # Only when broot is installed system-wide
    if command -v broot >/dev/null; then
      source <(broot --print-shell-function bash)
    fi
  '';
}
