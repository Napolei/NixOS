# Aggregator module for development IDEs and tools

{ config, pkgs, lib, ... }:

{
  imports = [
    ./direnv
    ./docker
    ./git
    ./oxker
    ./pycharm
    ./python
  ];
}
