# procs: ps replacement with colours, search and a tree view
# https://github.com/dalance/procs

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    procs
  ];
}
