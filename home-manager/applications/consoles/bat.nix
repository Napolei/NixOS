# bat settings (~/.config/bat/config)
# https://github.com/sharkdp/bat#configuration-file
# List themes with: bat --list-themes

{ vars, ... }:

{
  xdg.configFile."bat/config".text = ''
    # "ansi" uses the terminal colours (theme.colors, see terminal-colors.nix)
    --theme="ansi"
    --style="numbers,changes,header"
    --italic-text=always
  '';
}
