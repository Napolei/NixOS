# ==============================================================================
# Applications Flake for NixOS
# ==============================================================================
#
# This flake packages all system-level applications and program configurations
# as modular NixOS configurations and modules.
#
# USAGE:
#   In system flake.nix:
#     inputs.applications.url = "path:./applications";
#     inputs.applications.inputs.nixpkgs.follows = "nixpkgs";
#
#     modules = [
#       ./configuration.nix
#       applications.nixosModules.default
#     ];
# ==============================================================================

{
  description = "System applications and programs flake for NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosModules = {
      default = import ./default.nix;
      applications = import ./default.nix;

      # Categories
      consoles = import ./consoles;
      development = import ./development;
      web = import ./web;

      # Individual application / tool modules
      btop = import ./consoles/btop;
      curl = import ./web/curl;
      git = import ./development/git;
      htop = import ./consoles/htop;
      iotop = import ./consoles/iotop;
      kitty = import ./consoles/kitty;
      mssql-odbc = import ./development/mssql-odbc;
      nano = import ./consoles/nano;
      powerline = import ./consoles/powerline;
      pycharm = import ./development/pycharm;
      python = import ./development/python;
      wget = import ./web/wget;
    };

    # Convenient alias
    nixosModule = self.nixosModules.default;
  };
}
