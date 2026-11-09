# ==============================================================================
# Standalone Home Manager Flake for user: max
# ==============================================================================
#
# SETUP:
#   mkdir -p ~/.config/home-manager
#   cp -r /path/to/nix-os-configs/home-manager/* ~/.config/home-manager/
#
# FIRST-TIME ACTIVATION (if home-manager CLI is not yet installed in PATH):
#   nix run github:nix-community/home-manager/master -- switch --flake ~/.config/home-manager#max
#
# USAGE COMMANDS (once home-manager or NixOS rebuild is applied):
#   Apply changes:   home-manager switch --flake ~/.config/home-manager#max
#   Update inputs:   nix flake update --flake ~/.config/home-manager
#   Build/Test:      home-manager build --flake ~/.config/home-manager#max
# ==============================================================================

{
  description = "User standalone Home Manager configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      vars = import ./vars.nix;
    in
    {
      homeConfigurations = {
        ${vars.user.username} = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs vars; };
          modules = [
            ./home.nix
          ];
        };
      };
    };
}
