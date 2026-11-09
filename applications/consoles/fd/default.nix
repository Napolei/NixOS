# fd: fast and simple find replacement
# https://github.com/sharkdp/fd

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    fd
  ];
}
