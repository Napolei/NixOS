# Aggregator module for containers: Docker and its terminal UI

{ config, pkgs, lib, ... }:

{
  imports = [
    ./docker
    ./oxker
  ];
}
