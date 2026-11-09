# fselect: find files with SQL-like queries
# https://github.com/jhspetersson/fselect

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    fselect
  ];
}
