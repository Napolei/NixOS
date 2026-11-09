# lsd: ls replacement with icons and colors
# https://github.com/lsd-rs/lsd

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    lsd
  ];
}
