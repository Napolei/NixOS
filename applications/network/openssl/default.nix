{ config, pkgs, lib, ... }:

{
  environment.systemPackages = [
    pkgs.openssl
  ];
}
