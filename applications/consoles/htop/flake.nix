{
  description = "Htop package flake for NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosModules = {
      default = import ./default.nix;
      htop = import ./default.nix;
    };

    nixosModule = self.nixosModules.default;
  };
}
