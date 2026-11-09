# dust: disk usage of directories as a tree (du replacement)
# https://github.com/bootandy/dust

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    dust
  ];
}
