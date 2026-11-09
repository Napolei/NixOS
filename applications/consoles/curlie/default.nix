# curlie: curl with the interface of httpie
# https://github.com/rs/curlie

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    curlie
  ];
}
