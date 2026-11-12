# oh-my-posh: the bash prompt, built from segments (user, path, git, ...).
# Configured per user in home-manager/applications/terminal/oh-my-posh.nix,
# from prompt in home-manager/vars.nix.
# https://ohmyposh.dev

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    oh-my-posh
  ];
}
