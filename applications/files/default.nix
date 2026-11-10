# Aggregator module for file managers, file listings, directory navigation and archives

{ config, pkgs, lib, ... }:

{
  imports = [
    ./archives
    ./broot
    ./eza
    ./lsd
    ./nnn
    ./superfile
    ./yazi
    ./zoxide
  ];
}
