# Aggregator module for text editors and IDEs

{ config, pkgs, lib, ... }:

{
  imports = [
    ./micro
    ./nano
    ./neovim
    ./pycharm
  ];
}
