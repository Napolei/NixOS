# ==============================================================================
# Hardware configuration for WSL (Windows Subsystem for Linux)
# ==============================================================================
#
# Imported by configuration.nix. NixOS-WSL (flake input
# nixos-wsl) takes care of the root file system, booting inside WSL, running
# Windows programs and the default user.
#
# https://github.com/nix-community/NixOS-WSL
# https://nix-community.github.io/NixOS-WSL/options.html
# ==============================================================================

{ config, lib, pkgs, vars ? import ../../vars.nix { }, ... }:

{
  wsl = {
    enable = true;
    # User that `wsl -d NixOS` logs in as (instead of NixOS-WSL's "nixos")
    defaultUser = vars.user.username;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # GUI apps run through WSLg (Windows draws the windows)
  hardware.graphics.enable = true;
}
