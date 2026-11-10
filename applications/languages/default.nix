# Aggregator module for programming languages and their package managers

{ config, pkgs, lib, ... }:

{
  imports = [
    ./nodejs
    ./python
  ];
}
