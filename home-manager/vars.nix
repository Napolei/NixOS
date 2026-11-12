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
  # Prompt (powerline, applications/terminal/powerline.nix)
  # ----------------------------------------------------------------------------
  # Powerline shell themes:
  # - "default": the git branch on the right side of the line
  # - "default_leftonly": the git branch next to the path
  prompt = {
    # All terminals except the JetBrains ones
    theme = "default";
    # The terminal of PyCharm and the other JetBrains IDEs
    # (TERMINAL_EMULATOR=JetBrains-JediTerm). It can't draw the right side:
    # with "default", the cursor stays behind the branch and every key starts
    # a new line.
    jetbrainsTheme = "default_leftonly";
  };

  # ----------------------------------------------------------------------------
  # Theme: colour profile of the terminal and its tools (theme.nix)
  # ----------------------------------------------------------------------------
  theme = import ./theme.nix;
}
