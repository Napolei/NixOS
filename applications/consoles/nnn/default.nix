# nnn: fast terminal file manager
# https://github.com/jarun/nnn (wiki: https://github.com/jarun/nnn/wiki)
# Built with Nerd Font icons (JetBrainsMono Nerd Font is the system font)

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    (nnn.override { withNerdIcons = true; })
  ];
}
