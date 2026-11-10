# Terminal colours from theme.nix (colors): every terminal other than kitty
# (e.g. Windows Terminal) gets its 16-colour palette, text, background and
# cursor colours as escape sequences when bash starts. kitty has them in its
# config (kitty.nix). Terminal tools that use the palette (bat, fzf,
# nano, mcfly, eza, …) follow it.

{ lib, vars, ... }:

let
  themeLib = import ../../theme-lib.nix { inherit lib vars; };
in
{
  programs.bash.initExtra = ''
    if [ -z "$KITTY_WINDOW_ID" ] && [ -t 1 ]; then
      printf '%b' '${themeLib.sequences themeLib.palette}'
    fi
  '';
}
