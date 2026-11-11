# System-wide environment variables, set for every user and shell
# https://search.nixos.org/options?query=environment.variables

{ config, pkgs, lib, ... }:

{
  environment.variables = {
    # Bash history
    HISTCONTROL = "ignoredups";
    HISTSIZE = "200000";
    HISTFILESIZE = "200000";
    HISTTIMEFORMAT = "%Y/%m/%d-%H:%M	  ";

    # GUI apps open as Windows windows
    DISPLAY = ":0";
    WAYLAND_DISPLAY = "wayland-0";
    QT_QPA_PLATFORM = "xcb";

    # Opt out of telemetry in tools that follow this convention
    # https://consoledonottrack.com
    DO_NOT_TRACK = "1";
  };
}
