# bat settings (~/.config/bat/config)
# https://github.com/sharkdp/bat#configuration-file
# List themes with: bat --list-themes

{ vars, ... }:

{
  xdg.configFile."bat/config".text = ''
    # "ansi" uses the terminal colours (theme.colors, see terminal/terminal-colors.nix)
    --theme="ansi"
    --style="numbers,changes,header"
    --italic-text=always
  '';

  # Coloured man pages through bat, only when bat is installed system-wide
  # (otherwise man keeps PAGER). MANROFFOPT=-c keeps man's formatting codes
  # readable for col.
  # https://github.com/sharkdp/bat#man
  programs.bash.initExtra = ''
    if command -v bat >/dev/null; then
      export MANPAGER="sh -c 'col -bx | bat -l man -p'"
      export MANROFFOPT="-c"
    fi
  '';
}
