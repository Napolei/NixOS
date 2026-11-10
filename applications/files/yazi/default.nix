# yazi: terminal file manager with image previews
# https://yazi-rs.github.io

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    yazi
  ];
}
