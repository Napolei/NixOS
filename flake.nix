{
  description = "NixOS system configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    applications = {
      url = "path:./applications";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # System-wide environment variables
    environment = {
      url = "path:./environment";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # NixOS on WSL, enabled in hardware-configuration-wsl.nix
    # https://github.com/nix-community/NixOS-WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Prebuilt database for nix-index / comma (core/nix.nix)
    # https://github.com/nix-community/nix-index-database
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, applications, environment, nixos-wsl, nix-index-database, ... }@inputs:
    let
      # One configuration per distro, named after its hostname.
      # `nixos-rebuild switch --flake .` builds the one matching the current
      # hostname and stops if none does.
      hosts = [ "wsl" ];

      mkHost = hostName:
        let
          vars = import ./vars.nix { inherit hostName; };
        in
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs vars; };
          modules = [
            ./configuration.nix
            applications.nixosModules.default
            environment.nixosModules.default
            nixos-wsl.nixosModules.default
            nix-index-database.nixosModules.nix-index
          ];
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs hosts mkHost;
    };
}
