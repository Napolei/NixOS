# Aggregator module for development tools: version control and project environments

{ config, pkgs, lib, ... }:

{
  imports = [
    ./direnv
    ./git
  ];
}
