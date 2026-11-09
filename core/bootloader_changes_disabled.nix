{ config, pkgs, lib, ... }:

{
  boot.loader = {
    # Disable GRUB so NixOS does not attempt to write to /boot or EFI
    grub.enable = false;
    generic-extlinux-compatible.enable = false;
    systemd-boot.enable = false;
  };
}