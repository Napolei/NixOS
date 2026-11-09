# Powerline prompt colours from the theme (theme.nix: prompt): the user name
# on a light colour, the path and git on the terminal background lightened, so
# neighbouring segments differ in lightness, not only in hue.
# Powerline merges these files over its own (~/.config/powerline). It uses true
# colour, with the exact colours from theme.colors.
# https://powerline.readthedocs.io/en/master/configuration/reference.html

{ config, lib, vars, ... }:

let
  themeLib = import ../../theme-lib.nix { inherit lib vars; };

  group = fg: bg: attrs: { fg = "theme_${fg}"; bg = "theme_${bg}"; inherit attrs; };
in
{
  xdg.configFile."powerline/config.json".text = builtins.toJSON {
    common.term_truecolor = true;
  };

  xdg.configFile."powerline/colors.json".text = themeLib.powerline themeLib.palette;

  xdg.configFile."powerline/colorschemes/shell/default.json".text = builtins.toJSON {
    name = "Theme colours for shell prompts";
    groups = {
      user = group "dark" "user" [ "bold" ];
      hostname = group "text" "path" [ ];
      virtualenv = group "text" "path" [ ];
      environment = group "text" "path" [ ];
      # The path: parent folders dimmed, the current one bold
      "information:additional" = group "dimmed" "path" [ ];
      "information:regular" = group "text" "path" [ "bold" ];
      "information:priority" = group "dark" "warning" [ ];
      "cwd:divider" = group "dimmed" "path" [ ];
      branch = group "text" "path" [ ];
      branch_clean = group "text" "path" [ ];
      branch_dirty = group "warning" "path" [ ];
      "branch:divider" = group "dimmed" "path" [ ];
      jobnum = group "dark" "warning" [ ];
      exit_fail = group "dark" "error" [ "bold" ];
      exit_success = group "text" "path" [ ];
      "warning:regular" = group "dark" "warning" [ "bold" ];
      "critical:failure" = group "dark" "error" [ ];
      "critical:success" = group "text" "path" [ ];
      mode = group "dark" "accent" [ "bold" ];
    };
  };
}
