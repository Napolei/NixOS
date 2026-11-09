# eza: modern ls replacement with icons and git status
# https://eza.rocks/ (https://github.com/eza-community/eza)

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    eza
  ];
}
