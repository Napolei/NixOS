# btop colours from the theme, like the bar: accent highlights and graphs,
# surface boxes, the warning / error colours for high load. From theme.colors.
# https://github.com/aristocratos/btop#themes

{ config, pkgs, lib, vars, ... }:

let
  themeLib = import ../../theme-lib.nix { inherit lib vars; };

  # In btop's own themes folder, so its settings menu lists it too
  themeFile = "${config.xdg.configHome}/btop/themes/theme.theme";
  btopConf = "${config.xdg.configHome}/btop/btop.conf";
in
{
  xdg.configFile."btop/themes/theme.theme".text = themeLib.btop themeLib.palette;

  # btop.conf stays writable for btop's settings menu: only the theme lines
  # are set, the terminal background shows through
  home.activation.btopTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -f ${btopConf} ]; then
      ${pkgs.gnused}/bin/sed -i \
        -e 's|^color_theme = .*|color_theme = "${themeFile}"|' \
        -e 's/^theme_background = .*/theme_background = False/' ${btopConf}
    else
      mkdir -p ${config.xdg.configHome}/btop
      printf 'color_theme = "%s"\ntheme_background = False\n' ${themeFile} > ${btopConf}
    fi
  '';
}
