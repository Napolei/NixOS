# ==============================================================================
# Git User Settings for Home Manager
# ==============================================================================
#
# Git itself is installed system-wide via /applications/development/git.
# This only writes the user's git config (~/.config/git/config).

{ config, pkgs, lib, ... }:

{
  xdg.configFile."git/config".text = lib.generators.toGitINI {
    # Equivalent to: git config --global --add safe.directory '*'
    safe.directory = "*";
  };
}
