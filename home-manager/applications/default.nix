# ==============================================================================
# User Application Settings for Home Manager
# ==============================================================================
#
# Only user-specific settings live here. The applications themselves are
# installed system-wide via /applications (sudo nixos-rebuild switch --flake .).
#
# To add settings for another application, create a .nix file below and add it
# to the imports list.
# ==============================================================================

{
  imports = [
    ./consoles
    ./terminal-colors.nix
    ./development/git.nix
    ./development/oxker.nix
  ];
}
