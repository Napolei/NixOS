# Aggregator module for all application and program configurations, one
# folder per purpose

{ config, pkgs, lib, ... }:

{
  imports = [
    ./containers
    ./databases
    ./development
    ./editors
    ./files
    ./languages
    ./network
    ./search
    ./system
    ./terminal
    ./text
  ];
}
