# oxker colours (~/.config/oxker/config.toml; other settings keep their
# defaults): selections dark on the light highlight (theme.nix: highlight),
# the header bar raised. From theme.colors.
# https://github.com/mrjackwills/oxker/blob/main/example_config/example.config.toml

{ config, lib, vars, ... }:

let
  themeLib = import ../../theme-lib.nix { inherit lib vars; };
in
{
  xdg.configFile."oxker/config.toml" = { text = themeLib.oxker themeLib.palette; };
}
