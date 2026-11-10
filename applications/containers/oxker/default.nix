# oxker: terminal UI to view and control Docker containers
# https://github.com/mrjackwills/oxker

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    oxker
  ];
}
