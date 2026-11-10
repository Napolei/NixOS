# ==============================================================================
# User Application Settings for Home Manager
# ==============================================================================
#
# Only user-specific settings live here. The applications themselves are
# installed system-wide via /applications (sudo nixos-rebuild switch --flake .).
#
# One folder per purpose, like /applications. To add settings for another
# application, create a .nix file in its folder and add it to that folder's
# default.nix.
# ==============================================================================

{
  imports = [
    ./containers
    ./development
    ./editors
    ./files
    ./network
    ./search
    ./system
    ./terminal
    ./text
  ];
}
