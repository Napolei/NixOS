# DNS lookups: dig, nslookup, host
# https://www.isc.org/bind/

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = [ pkgs.dnsutils ];
}
