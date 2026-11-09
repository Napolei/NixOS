{ config, pkgs, lib, ... }:

{
  virtualisation.docker = {
    enable = true;

    # /etc/docker/daemon.json
    daemon.settings = {
      # Give each new network (default bridge, compose networks) a /28 subnet
      # instead of a /16 or /20
      default-address-pools = [
        { base = "172.17.0.0/12"; size = 28; }
      ];
    };
  };
}
