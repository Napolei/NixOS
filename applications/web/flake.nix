{
  description = "Web and networking applications flake for NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosModules = {
      default = import ./default.nix;
      web = import ./default.nix;
      curl = import ./curl;
      wget = import ./wget;
    };

    nixosModule = self.nixosModules.default;
  };
}
