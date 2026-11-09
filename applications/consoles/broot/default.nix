# broot: interactive directory tree navigator (br)
# https://dystroy.org/broot/

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    broot
  ];
}
