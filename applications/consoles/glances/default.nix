# glances: system monitoring tool (top/htop alternative)
# https://glances.readthedocs.io/ (https://github.com/nicolargo/glances)

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    glances
  ];
}
