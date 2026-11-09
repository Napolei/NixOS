# In system/shell/env.nix
{ config, pkgs, lib, ... }:

{
  environment.variables = {
    HISTCONTROL = "ignoredups";
    HISTSIZE = "200000";
    HISTFILESIZE = "200000";
    HISTTIMEFORMAT = "%Y/%m/%d-%H:%M	  ";

    # GUI apps open as Windows windows
    DISPLAY = ":0";
    WAYLAND_DISPLAY = "wayland-0";
    QT_QPA_PLATFORM = "xcb";
  };
}
