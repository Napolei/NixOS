# superfile: terminal file manager (spf)
# https://superfile.dev

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    superfile
  ];
}
