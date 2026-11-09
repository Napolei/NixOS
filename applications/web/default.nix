# Aggregator module for web and networking applications

{ config, pkgs, lib, ... }:

{
  imports = [
    ./curl
    ./wget
  ];
}
