# Small system tools: file type, directory tree, open files, PCI / USB devices, DNS lookups
# file, tree, lsof, lspci, lsusb, dig / nslookup

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    file
    tree
    lsof
    pciutils
    usbutils
    dnsutils
  ];
}
