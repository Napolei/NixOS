# Aggregator module for searching files and text, fuzzy finding

{ config, pkgs, lib, ... }:

{
  imports = [
    ./fd
    ./fselect
    ./fzf
    ./ripgrep
  ];
}
