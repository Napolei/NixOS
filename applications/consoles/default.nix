# Aggregator module for console applications and terminal tools

{ config, pkgs, lib, ... }:

{
  imports = [
    ./archives
    ./bat
    ./broot
    ./btop
    ./choose
    ./curlie
    ./duf
    ./dust
    ./eza
    ./fd
    ./fselect
    ./fzf
    ./glances
    ./gping
    ./htop
    ./httpie
    ./iotop
    ./jq
    ./kitty
    ./lsd
    ./mcfly
    ./micro
    ./nano
    ./neovim
    ./nnn
    ./pay-respects
    ./powerline
    ./procs
    ./rclone
    ./ripgrep
    ./superfile
    ./system-tools
    ./tealdeer
    ./tmux
    ./yazi
    ./zoxide
  ];
}
