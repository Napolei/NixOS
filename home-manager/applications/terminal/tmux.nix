# tmux settings (~/.config/tmux/tmux.conf): true colour, and the theme for the
# status bar, pane borders and selection (theme.nix: highlight, raisedLighten),
# from theme.colors
# https://github.com/tmux/tmux/wiki/Getting-Started

{ config, lib, vars, ... }:

let
  themeLib = import ../../theme-lib.nix { inherit lib vars; };
in
{
  xdg.configFile."tmux/colors.conf" = { text = themeLib.tmux themeLib.palette; };

  xdg.configFile."tmux/tmux.conf".text = ''
    # True colour in kitty and other terminals that support it
    set -g default-terminal "tmux-256color"
    set -as terminal-features ",xterm-kitty:RGB,xterm-256color:RGB"

    source-file -q ${config.xdg.configHome}/tmux/colors.conf
  '';
}
