{ config, pkgs, lib, vars, ... }:

{
  # Set your time zone.
  time.timeZone = vars.system.timeZone;

  # Select internationalisation properties.
  i18n.defaultLocale = vars.system.defaultLocale;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = vars.system.keyboardLayout;
    variant = "";
  };

  # Configure console keymap
  console.keyMap = vars.system.keyboardLayout;
}
