# wsl-open: opens files and links with their Windows default app. BROWSER
# makes gh, Python's webbrowser, Jupyter, ... open links in the Windows
# default browser. (wslu's wslview did the same; nixpkgs dropped it in 2026,
# the project is archived.)
# https://github.com/4U6U/wsl-open

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    wsl-open
  ];

  environment.variables.BROWSER = "wsl-open";
}
