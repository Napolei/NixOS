# Neovim: terminal editor (nvim), nano stays the default editor
# https://neovim.io

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
  ];
}
