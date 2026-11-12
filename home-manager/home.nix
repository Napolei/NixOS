# ==============================================================================
# Home Manager Configuration for user: max
# ==============================================================================
#
# SETUP INSTRUCTIONS:
# 1. Copy this folder to your home directory configuration:
#      mkdir -p ~/.config/home-manager
#      cp -r /path/to/nix-os-configs/home-manager/* ~/.config/home-manager/
#
# 2. First-time bootstrap / switch (if home-manager CLI is not yet in PATH):
#      nix run github:nix-community/home-manager/master -- switch --flake ~/.config/home-manager#max
#    Or after rebuilding NixOS (with pkgs.home-manager in system/user packages):
#      home-manager switch --flake ~/.config/home-manager#max
#
# APPLYING CHANGES:
# When you update this file (e.g. adding packages, modifying programs), run:
#      home-manager switch --flake ~/.config/home-manager#max
#
# (Or if you are inside ~/.config/home-manager):
#      home-manager switch --flake .#max
#
# UPDATING PACKAGES / FLAKE INPUTS:
# To update dependencies (nixpkgs / home-manager) to their latest versions:
#      cd ~/.config/home-manager
#      nix flake update
#      home-manager switch --flake .#max
#
# TESTING WITHOUT SWITCHING:
# To build and test your configuration without activating:
#      home-manager build --flake ~/.config/home-manager#max
# ==============================================================================

{ config, pkgs, vars, ... }:

{
  # Per-user application settings (programs themselves are installed system-wide)
  imports = [
    ./applications
    ./shell/aliases.nix
    ./shell/env.nix
  ];

  # Home Manager configuration for user environment
  home = {
    username = vars.user.username;
    homeDirectory = vars.user.homeDirectory;
    stateVersion = vars.stateVersion;

    # Move existing files that are in the way to <file>.backup instead of failing
    # (standalone equivalent of `home-manager switch -b backup`)
    backupFileExtension = "backup";
    overwriteBackup = true;

    # Declare user-specific packages here without modifying nix-env
    packages = with pkgs; [
      # User packages can be added here
    ];
  };

  # User-specific shell configuration
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      # Powerline draws the right side of the prompt (git branch) with the
      # cursor save / restore codes (ESC[s, ESC[u), which PyCharm's terminal
      # (JediTerm) ignores: the cursor stayed behind the branch and every key
      # started a new line. There the branch goes on the left instead.
      if [[ ''${TERMINAL_EMULATOR-} == JetBrains-JediTerm ]]; then
        export POWERLINE_CONFIG_OVERRIDES="ext.shell.theme=default_leftonly"
      fi
      . ${pkgs.powerline}/share/bash/powerline.sh
    '';
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
