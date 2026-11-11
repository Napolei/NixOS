# Aggregator module for system monitoring, disk usage, system information and
# WSL utilities

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
    ./wsl-open
  ];
}
