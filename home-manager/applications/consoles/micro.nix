# micro colour scheme "theme" (~/.config/micro/colorschemes/theme.micro), from
# theme.colors, in true colour.
# settings.json stays writable for micro's `set` command; every switch only
# sets its colorscheme.
# https://github.com/micro-editor/micro/blob/master/runtime/help/colors.md

{ config, pkgs, lib, vars, ... }:

let
  themeLib = import ../../theme-lib.nix { inherit lib vars; };
  settings = "${config.xdg.configHome}/micro/settings.json";
in
{
  xdg.configFile."micro/colorschemes/theme.micro" = { text = themeLib.micro themeLib.palette; };

  # Exact colours instead of the nearest of 256
  home.sessionVariables.MICRO_TRUECOLOR = "1";

  home.activation.microTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${config.xdg.configHome}/micro
    [ -s ${settings} ] || echo '{}' > ${settings}
    tmp=$(mktemp)
    if ${pkgs.jq}/bin/jq '.colorscheme = "theme"' ${settings} > "$tmp"; then
      mv "$tmp" ${settings}
    else
      rm -f "$tmp"
    fi
  '';
}
