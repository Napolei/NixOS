{ config, pkgs, lib, ... }:

{
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true; # Require password for sudo (default: user's password)
    configFile = ''
      # how often to reenter pw on sudo (in minutes)
      Defaults timestamp_timeout=600
    '';
  };
}
