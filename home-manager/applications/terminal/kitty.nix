# kitty settings (~/.config/kitty/kitty.conf)
# https://sw.kovidgoyal.net/kitty/conf/

{ lib, vars, ... }:

let
  themeLib = import ../../theme-lib.nix { inherit lib vars; };
in
{
  xdg.configFile."kitty/kitty.conf".text = ''
    font_family ${vars.theme.kitty.font}
    font_size ${toString vars.theme.kitty.fontSize}

    # Colours from theme.colors
    include colors.conf
  '';

  xdg.configFile."kitty/colors.conf".text = themeLib.kitty themeLib.palette;
}
