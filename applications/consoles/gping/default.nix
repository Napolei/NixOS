# gping: ping with a live graph, several hosts at once
# https://github.com/orf/gping

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    gping
  ];
}
