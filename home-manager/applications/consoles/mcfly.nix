# mcfly: CTRL-R searches the shell history, ranked by directory and context
# https://github.com/cantino/mcfly#settings

{ lib, ... }:

{
  # After fzf (fzf.nix), so mcfly gets CTRL-R
  programs.bash.initExtra = lib.mkAfter ''
    # Only when mcfly is installed system-wide
    if command -v mcfly >/dev/null; then
      eval "$(mcfly init bash)"
    fi
  '';

  home.sessionVariables = {
    # Fuzzy matching, higher values rank more exact matches first
    MCFLY_FUZZY = "2";
    MCFLY_RESULTS = "50";
    # Results below the prompt, like a dropdown
    MCFLY_INTERFACE_VIEW = "BOTTOM";
    # Delete history entries with the delete key without asking
    MCFLY_DELETE_WITHOUT_CONFIRM = "true";
  };

  # The menu bar is white on blue by default; the terminal's blue
  # (theme.colors) can be as light as the text. Black and white are the
  # background and foreground, which always contrast: the bar in the text
  # colour with the background colour on it. The selected result is dark
  # instead of light by default: the time on the right keeps its colour (blue,
  # light) on the selected line too. color1 ("dark_red") is a dark colour, the
  # text and matches stay in the colours of the other lines. mcfly only takes
  # the 16 terminal colour names. Read from here unless ~/.mcfly exists.
  xdg.dataFile."mcfly/config.toml".text = ''
    [colors.menubar]
    bg = "white"
    fg = "black"

    [colors.darkmode]
    results_selection_bg = "dark_red"
    results_selection_fg = "white"
    results_selection_hl = "blue"
  '';
}
