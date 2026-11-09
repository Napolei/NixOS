# micro: terminal text editor with common shortcuts (Ctrl+S, Ctrl+C, mouse)
# https://micro-editor.github.io

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    micro
  ];
}
