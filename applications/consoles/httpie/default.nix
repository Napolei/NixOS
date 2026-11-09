# httpie: human-friendly HTTP client (http, https)
# https://httpie.io/docs/cli (https://github.com/httpie/cli)

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    httpie
  ];
}
