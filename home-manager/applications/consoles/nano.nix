# nano interface colours, read after the system-wide /etc/nanorc (syntax
# highlighting, tabs: /applications/consoles/nano)
# https://www.nano-editor.org/dist/latest/nanorc.5.html

{ lib, vars, ... }:

let
  # nano name of the terminal palette colour of a role (roles in theme.nix),
  # e.g. accent = color4 -> "blue", color12 -> "lightblue". The terminal
  # palette is set from theme.colors, so nano follows the theme.
  names = [ "black" "red" "green" "yellow" "blue" "magenta" "cyan" "white" ];
  color = role:
    let n = lib.toInt (lib.removePrefix "color" vars.theme.roles.${role});
    in (if n >= 8 then "light" else "") + builtins.elemAt names (lib.mod n 8);

  accent = color "accent";
  surface = color "surface";
  dimmed = color "dimmed";
  error = color "error";
  warning = color "warning";
in
{
  xdg.configFile."nano/nanorc".text = ''
    # Title bar and mini bar in the accent colour, like the bar's highlights
    set titlecolor bold,black,${accent}
    set minicolor black,${accent}
    set statuscolor bold,${accent}
    set promptcolor bold,${accent}
    set errorcolor bold,black,${error}
    # Shortcut list at the bottom
    set keycolor bold,${accent}
    set functioncolor ${dimmed}
    # Text area
    set selectedcolor black,${accent}
    set spotlightcolor black,${warning}
    set numbercolor ${surface}
    set stripecolor ,${surface}
    set scrollercolor ${accent}
  '';
}
