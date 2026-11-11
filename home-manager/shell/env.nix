# ==============================================================================
# Environment Variables for Home Manager
# ==============================================================================
#
# User-specific environment variables, added on top of the system-wide ones
# from /environment (its own flake). A variable with the same name overrides
# the system-wide one for this user. Variables of a single program stay in
# that program's module (e.g. applications/files/nnn.nix).
# Takes effect in new login shells (~/.profile sources hm-session-vars.sh).
# https://nix-community.github.io/home-manager/options.xhtml#opt-home.sessionVariables

{ config, pkgs, lib, ... }:

{
  home.sessionVariables = {
    # Editor for git commits, crontab -e, sudoedit, ... (micro is installed
    # system-wide, see applications/editors/micro)
    EDITOR = "micro";
    VISUAL = "micro";

    # Pager for man, git, ...; -R keeps colours, -F quits when the text fits
    # on one screen
    PAGER = "less";
    LESS = "-RF";
  };
}
