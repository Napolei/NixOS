# Aggregator module for the terminal, its multiplexer, prompt and shell helpers

{ config, pkgs, lib, ... }:

{
  imports = [
    ./kitty
    ./mcfly
    ./oh-my-posh
    ./pay-respects
    ./powerline
    ./tealdeer
    ./tmux
  ];
}
