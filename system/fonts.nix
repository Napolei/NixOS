{ config, pkgs, lib, ... }:

{
  environment.systemPackages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [];
        # JetBrains Mono as default for all font types
        sansSerif = [ "JetBrainsMono Nerd Font" ];
        serif = [ "JetBrainsMono Nerd Font" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };
  };
}
