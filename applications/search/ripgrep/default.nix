# ripgrep: fast recursive text search (rg, grep replacement)
# https://github.com/BurntSushi/ripgrep

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    ripgrep
  ];
}
