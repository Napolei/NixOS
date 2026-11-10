# Aggregator module for network clients, transfers and diagnostics

{ config, pkgs, lib, ... }:

{
  imports = [
    ./curl
    ./curlie
    ./dnsutils
    ./gping
    ./httpie
    ./rclone
    ./wget
  ];
}
