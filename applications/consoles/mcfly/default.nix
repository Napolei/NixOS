# mcfly: smart shell history search (CTRL-R)
# https://github.com/cantino/mcfly

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    mcfly
  ];
}
