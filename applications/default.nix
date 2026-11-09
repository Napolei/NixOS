# Aggregator module for all application and program configurations

{ config, pkgs, lib, ... }:

{
  imports = [
    ./consoles
    ./development
    ./web
  ];
}
