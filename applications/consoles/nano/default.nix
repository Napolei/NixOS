{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    nano
  ];

  # https://www.nano-editor.org/dist/latest/nanorc.5.html
  # (Smooth line-by-line scrolling is the default; the old `set smooth` no
  # longer exists. Colours are per user: home-manager/applications/consoles/nano.nix)
  programs.nano.nanorc = ''
    set tabstospaces
    set tabsize 2
    # Copy the indentation of the previous line
    set autoindent
    # Wrap long lines on screen (not in the file), at spaces
    set softwrap
    set atblanks
    set linenumbers
    # Click to place the cursor, double-click to select; Shift+drag still
    # selects text for the terminal's clipboard
    set mouse
    # Home jumps to the first non-blank character of the line first
    set smarthome
  '';
}
