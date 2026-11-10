# ==============================================================================
# Development Applications Flake for NixOS
# ==============================================================================
#
# This flake provides NixOS modules and configurations for development IDEs:
# PyCharm.
#
# USAGE:
#   In applications/flake.nix or system flake.nix:
#     inputs.development.url = "path:./development"; # or path:./applications/development
#     inputs.development.inputs.nixpkgs.follows = "nixpkgs";
#
#     modules = [
#       development.nixosModules.default # or individual IDE modules
#     ];
# ==============================================================================

{
  description = "Development IDEs (PyCharm) flake for NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosModules = {
      default = import ./default.nix;
      development = import ./default.nix;
      direnv = import ./direnv;
      git = import ./git;
      mssql-odbc = import ./mssql-odbc;
      nodejs = import ./nodejs;
      pycharm = import ./pycharm;
      python = import ./python;
    };

    # Convenient alias
    nixosModule = self.nixosModules.default;
  };
}
