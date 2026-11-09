{ config, pkgs, lib, ... }:

{
  programs.bash.shellAliases = {
    l = "ls -alh";
    ll = "ls -lAv --color=tty";
    ls = "ls --color=tty";
  };
}
