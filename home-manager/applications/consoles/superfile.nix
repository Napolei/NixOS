# superfile theme "theme" (~/.config/superfile/theme/theme.toml), from
# theme.colors. config.toml stays writable: it is
# created from superfile's default on the first switch, and every switch only
# sets its `theme` line.
# https://superfile.dev/configure/custom-theme/

{ config, pkgs, lib, vars, ... }:

let
  themeLib = import ../../theme-lib.nix { inherit lib vars; };
  configToml = "${config.xdg.configHome}/superfile/config.toml";
in
{
  xdg.configFile."superfile/theme/theme.toml" = { text = themeLib.superfile themeLib.palette; };

  home.activation.superfileTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f ${configToml} ]; then
      mkdir -p ${config.xdg.configHome}/superfile
      install -m 644 ${pkgs.superfile.src}/src/superfile_config/config.toml ${configToml}
    fi
    ${pkgs.gnused}/bin/sed -i 's/^theme = .*/theme = "theme"/' ${configToml}
  '';
}
