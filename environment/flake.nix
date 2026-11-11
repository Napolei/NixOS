# ==============================================================================
# Environment Variables Flake for NixOS
# ==============================================================================
#
# This flake exports the system-wide environment variables as a NixOS module.
# Variables that belong to one program stay in that program's module
# (e.g. NPM_CONFIG_PREFIX in applications/languages/nodejs).
#
# USAGE:
#   In system flake.nix:
#     inputs.environment.url = "path:./environment";
#     inputs.environment.inputs.nixpkgs.follows = "nixpkgs";
#
#     modules = [
#       ./configuration.nix
#       environment.nixosModules.default
#     ];
# ==============================================================================

{
  description = "System environment variables flake for NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosModules = {
      default = import ./default.nix;
      environment = import ./default.nix;
    };

    nixosModule = self.nixosModules.default;
  };
}
