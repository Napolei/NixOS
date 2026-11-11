# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, vars ? import ./vars.nix { }, ... }:

{
  _module.args.vars = vars;

  imports = [
    # Core system
    # No boot loader: Windows starts the distro
    ./core/bootloader_changes_disabled.nix
    ./core/security.nix
    ./core/users.nix
    ./core/locale.nix
    ./core/nix.nix

    # System & Hardware
    ./system/hardware/hardware-configuration-wsl.nix
    ./system/fonts.nix
    ./system/networking.nix
    ./system/shell/aliases.nix
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = vars.system.stateVersion; # Did you read the comment?
}
