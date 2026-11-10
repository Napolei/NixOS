# choose: select fields from lines, a friendlier cut / awk '{print $1}'
# https://github.com/theryangeary/choose

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    choose
  ];
}
