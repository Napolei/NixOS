# tealdeer: fast tldr client, simplified man pages (tldr)
# https://tealdeer-rs.github.io/tealdeer/ (https://github.com/tealdeer-rs/tealdeer)

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    tealdeer
  ];
}
