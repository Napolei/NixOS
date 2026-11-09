{ config, pkgs, lib, ... }:

{
  # Enable flakes and new nix command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Replace identical files in the store with hard links (saves disk space)
  nix.settings.auto-optimise-store = true;

  # nh: rebuild with a readable list of changed packages, and clean up old
  # generations weekly (keeps the last 5 and everything from the last 14 days).
  # `nh os switch` is the same as `nrs` plus the diff.
  # https://github.com/nix-community/nh
  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
    clean = {
      enable = true;
      extraArgs = "--keep-since 14d --keep 5";
    };
  };

  # Command not found: suggests the package, and `, <program>` runs a program
  # without installing it. Uses the weekly prebuilt database from the
  # nix-index-database flake input (flake.nix).
  # https://github.com/nix-community/nix-index-database
  programs.nix-index-database.comma.enable = true;
  # Doesn't work with flakes (no channel), replaced by nix-index
  programs.command-not-found.enable = false;

  # Ensure /bin/true exists for standard FHS compatibility and the services below
  system.activationScripts.binTrue = ''
    mkdir -m 0755 -p /bin
    ln -sfn ${pkgs.coreutils}/bin/true /bin/true
  '';

  # Declarative override for the cross-distribution mount guard, for a clean startup
  systemd.services.wsl-mnt-guard = {
    description = "Cross-Distribution Mount Guard";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/true";
      RemainAfterExit = true;
    };
  };
}
