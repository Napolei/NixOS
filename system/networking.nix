{ config, pkgs, lib, vars ? import ../vars.nix { }, ... }:

{
  # Name of the host's configuration in flake.nix (hosts), so a rebuild picks it
  networking.hostName = vars.hostName;

  # Networking is handled by the Windows host: no NetworkManager, firewall or
  # wpa_supplicant
  networking.networkmanager.enable = false;
  networking.firewall.enable = false;
  systemd.services.wpa_supplicant.enable = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
}
