# direnv: loads a project's environment (e.g. a Nix dev shell) when entering its
# directory; nix-direnv caches it. Per project: `echo "use flake" > .envrc && direnv allow`
# https://direnv.net
# https://github.com/nix-community/nix-direnv

{ config, pkgs, lib, ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
