{ config, pkgs, lib, vars, ... }:

{
  # Define the user account from global variables
  users.users."${vars.user.username}" = {
    isNormalUser = true;
    description = vars.user.description;
    extraGroups = [
      "wheel"
      "docker"
    ];
    uid = vars.user.uid;
    hashedPassword = vars.user.hashedPassword;
    packages = with pkgs; [
      home-manager
    ];
  };
}
