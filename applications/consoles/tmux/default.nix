# tmux: terminal multiplexer (split panes, windows, detachable sessions)
# https://github.com/tmux/tmux/wiki

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    tmux
  ];
}
