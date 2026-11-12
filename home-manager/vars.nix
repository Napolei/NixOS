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
  # Prompt (applications/terminal/oh-my-posh.nix, powerline.nix)
  # ----------------------------------------------------------------------------
  prompt = {
    # Program that draws the bash prompt: "oh-my-posh" or "powerline"
    engine = "oh-my-posh";

    # oh-my-posh theme, by file name: a file in oh-my-posh/ next to this file
    # (theme.omp.json is the default prompt), or a theme that comes with
    # oh-my-posh, e.g. "agnoster" (previews: https://ohmyposh.dev/docs/themes).
    # JSON files in oh-my-posh/ can use the colours of theme.nix as
    # "p:<name>": text, dark, user, path, accent, dimmed, warning, error.
    # How to write a theme: https://ohmyposh.dev/docs/configuration/general
    ohMyPosh = {
      # All terminals except the JetBrains ones
      theme = "theme.omp.json";
      # The terminal of PyCharm and the other JetBrains IDEs
      # (TERMINAL_EMULATOR=JetBrains-JediTerm). theme-jetbrains.omp.json is
      # theme.omp.json with the right side at the end of the left one, in case
      # that terminal draws the right side wrong.
      jetbrainsTheme = "theme-jetbrains.omp.json";
    };

    # powerline shell themes:
    # - "default": the git branch on the right side of the line
    # - "default_leftonly": the git branch next to the path
    powerline = {
      # All terminals except the JetBrains ones
      theme = "default";
      # The terminal of PyCharm and the other JetBrains IDEs
      # (TERMINAL_EMULATOR=JetBrains-JediTerm). It can't draw powerline's
      # right side: with "default", the cursor stays behind the branch and
      # every key starts a new line.
      jetbrainsTheme = "default_leftonly";
    };
  };

  # ----------------------------------------------------------------------------
  # Theme: colour profile of the terminal and its tools (theme.nix)
  # ----------------------------------------------------------------------------
  theme = import ./theme.nix;
}
