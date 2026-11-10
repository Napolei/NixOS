# fzf: command-line fuzzy finder
# https://junegunn.github.io/fzf/ (https://github.com/junegunn/fzf)

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    fzf
  ];
}
