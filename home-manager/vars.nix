# ==============================================================================
# User Configuration Variables for Home Manager
# ==============================================================================
#
# Per-user settings for this Home Manager template. Adjust these after copying
# the template to ~/.config/home-manager.
#
# USAGE:
# - Injected into all Home Manager modules via `extraSpecialArgs`.
# - In Modules: Access directly in module arguments `{ config, pkgs, lib, vars, ... }:`.
# - Apply with: home-manager switch --flake ~/.config/home-manager#<user.username>
# - The colour profile (palette, roles, font) is in theme.nix.
# ==============================================================================

{
  # ----------------------------------------------------------------------------
  # User Account
  # ----------------------------------------------------------------------------
  user = {
    username = "max";
    homeDirectory = "/home/max";
  };

  # Home Manager state version, keep at the version of the first activation
  stateVersion = "26.05";

  # ----------------------------------------------------------------------------
  # Theme: colour profile of the terminal and its tools (theme.nix)
  # ----------------------------------------------------------------------------
  theme = import ./theme.nix;
}
