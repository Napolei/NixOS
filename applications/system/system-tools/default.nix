# Small system tools: file type, directory tree, open files, PCI / USB devices
# file, tree, lsof, lspci, lsusb

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    file
    tree
    lsof
    pciutils
    usbutils
  ];
}
