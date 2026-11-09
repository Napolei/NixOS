# bat: cat with syntax highlighting and git integration
# https://github.com/sharkdp/bat

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    bat
  ];
}
