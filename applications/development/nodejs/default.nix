# Node.js (current LTS release in nixpkgs), with npm and npx
# https://nodejs.org
# https://docs.npmjs.com

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    nodejs
  ];
}
