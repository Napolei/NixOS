# duf: disk usage / free space overview (df replacement)
# https://github.com/muesli/duf

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    duf
  ];
}
