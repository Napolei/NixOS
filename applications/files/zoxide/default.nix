# zoxide: smarter cd that remembers directories (z, and zi with fzf)
# https://github.com/ajeetdsouza/zoxide
# Replaces z (rupa/z) and fz (z + fzf)

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    zoxide
  ];
}
