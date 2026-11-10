# ripgrep colours (RIPGREP_CONFIG_PATH): matches dark on the light highlight
# (theme.nix: highlight), paths in the accent colour, line numbers dimmed.
# From theme.colors.
# https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file

{ config, lib, vars, ... }:

let
  themeLib = import ../../theme-lib.nix { inherit lib vars; };
in
{
  xdg.configFile."ripgrep/config" = { text = themeLib.ripgrep themeLib.palette; };

  home.sessionVariables.RIPGREP_CONFIG_PATH = "${config.xdg.configHome}/ripgrep/config";
}
