# pay-respects: corrects the previous command (replacement for thefuck / fuck)
# https://github.com/iffse/pay-respects
# thefuck was removed from nixpkgs (unmaintained upstream)

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    pay-respects
  ];
}
