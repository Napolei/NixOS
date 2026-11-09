# yazi theme (~/.config/yazi/theme.toml, merged over yazi's own): the active
# tab, mode and hovered file dark on the light highlight (theme.nix:
# highlight), the status bar raised. From theme.colors.
# https://yazi-rs.github.io/docs/configuration/theme

{ config, lib, vars, ... }:

let
  themeLib = import ../../theme-lib.nix { inherit lib vars; };
in
{
  xdg.configFile."yazi/theme.toml" = { text = themeLib.yazi themeLib.palette; };
}
