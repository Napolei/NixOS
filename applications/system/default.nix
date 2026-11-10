# Aggregator module for system monitoring, disk usage and system information

{ config, pkgs, lib, ... }:

{
  imports = [
    ./btop
    ./duf
    ./dust
    ./glances
    ./htop
    ./iotop
    ./procs
    ./system-tools
  ];
}
