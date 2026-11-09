# Archive tools: zip / unzip and 7-Zip (7z, also extracts rar)
# https://github.com/p7zip-project/p7zip

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    zip
    unzip
    p7zip
  ];
}
