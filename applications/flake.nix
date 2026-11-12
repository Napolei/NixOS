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

      # Groups, one per purpose
      containers = import ./containers;
      databases = import ./databases;
      development = import ./development;
      editors = import ./editors;
      files = import ./files;
      languages = import ./languages;
      network = import ./network;
      search = import ./search;
      system = import ./system;
      terminal = import ./terminal;
      text = import ./text;

      # Individual application / tool modules
      btop = import ./system/btop;
      curl = import ./network/curl;
      direnv = import ./development/direnv;
      git = import ./development/git;
      htop = import ./system/htop;
      iotop = import ./system/iotop;
      kitty = import ./terminal/kitty;
      mssql-odbc = import ./databases/mssql-odbc;
      nano = import ./editors/nano;
      nodejs = import ./languages/nodejs;
      oh-my-posh = import ./terminal/oh-my-posh;
      powerline = import ./terminal/powerline;
      pycharm = import ./editors/pycharm;
      python = import ./languages/python;
      wget = import ./network/wget;
      wsl-open = import ./system/wsl-open;
    };

    # Convenient alias
    nixosModule = self.nixosModules.default;
  };
}
