{
  description = "Console applications and terminal tools flake for NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosModules = {
      default = import ./default.nix;
      consoles = import ./default.nix;
      btop = import ./btop;
      htop = import ./htop;
      iotop = import ./iotop;
      kitty = import ./kitty;
      nano = import ./nano;
      powerline = import ./powerline;
    };

    nixosModule = self.nixosModules.default;
  };
}
