# ==============================================================================
# Theme for Home Manager
# ==============================================================================
#
# The colour profile of the terminal and its tools: the palette, the roles,
# the highlights and the terminal font.
#
# USAGE:
# - Imported in vars.nix as `theme`, so modules read it as `vars.theme`.
# - The base values at the top are referenced by the sections below (e.g.
#   `prompt.user = highlight;`). Change a base value to change it everywhere;
#   replace a reference with a value to change only that one.
# ==============================================================================

rec {
  # ----------------------------------------------------------------------------
  # Base values
  # ----------------------------------------------------------------------------
  # Hex colours without "#", in the 16-colour terminal layout. Generated once
  # with pywal16 from the former wallpaper (fhi9kqtf5oqh1.jpg, backend
  # modern_colorthief, saturate 0.6) and kept as they are.
  colors = {
    background = "001620";
    foreground = "c1c4c5";
    color0 = "001620"; color8 = "1d77a8";
    color1 = "851f0f"; color9 = "f86921";
    color2 = "0372b2"; color10 = "61dfc2";
    color3 = "058bae"; color11 = "f6af7c";
    color4 = "1893b9"; color12 = "ffc69a";
    color5 = "d84800"; color13 = "eef2a4";
    color6 = "db3e15"; color14 = "feedd7";
    color7 = "c1c4c5"; color15 = "c1c4c5";
  };

  # Error / warning in the true-colour programs (btop, Neovim, the prompt,
  # tmux, yazi, superfile, micro, oxker): red and yellow (Catppuccin Mocha),
  # so they stand out from the palette above
  alerts = {
    error = "f38ba8";
    warning = "f9e2af";
  };

  # Which palette colour each role uses
  roles = {
    accent = "color4";    # focus, selection, prompt, matches
    secondary = "color2"; # second accent, e.g. btop's free memory
    surface = "color8";   # selected rows, borders
    dimmed = "color7";    # secondary text
    # Only for programs limited to the 16 terminal colours (nano); the others
    # use alerts above
    error = "color1";     # errors
    warning = "color3";   # warnings
  };

  # Highlights in the prompt and terminal programs (tmux, yazi, superfile,
  # micro, oxker, ripgrep) differ from their surroundings in lightness, not
  # only in hue, so they stay apart for colour-blind eyes too.
  # Light highlight (active tab, selection, ripgrep matches) with the
  # background colour as text: a light role or palette colour, e.g. "color15",
  # "color7" or "dimmed"
  highlight = "color15";
  # Raised areas (status bars, the path in the prompt): the background
  # lightened by this many percent, with the foreground as text. Higher stands
  # out more; above about 35 the text gets hard to read.
  raisedLighten = 25;

  # Font of the terminal
  font = "JetBrainsMono Nerd Font";

  # ----------------------------------------------------------------------------
  # Powerline prompt (applications/consoles/powerline.nix)
  # ----------------------------------------------------------------------------
  # Neighbouring segments differ in lightness, not only in hue (see highlight
  # and raisedLighten above)
  prompt = {
    # Background of the user name, with the terminal background as text
    user = highlight;
    # Background of the path and the git branch: the terminal background
    # lightened by this many percent, with the foreground as text
    pathLighten = raisedLighten;
  };

  # ----------------------------------------------------------------------------
  # Terminal, kitty (applications/consoles/kitty.nix)
  # ----------------------------------------------------------------------------
  kitty = {
    inherit font;
    # Font size in points. WSLg doesn't scale Linux apps for high-DPI screens
    # unless set up in %USERPROFILE%\.wslgconfig.
    fontSize = 16;
  };
}
