# ==============================================================================
# Bash Aliases for Home Manager
# ==============================================================================
#
# User-specific aliases, added on top of the system-wide aliases from
# /system/shell/aliases.nix. An alias with the same name overrides the
# system-wide one for this user.

{ config, pkgs, lib, ... }:

{
  programs.bash.shellAliases = {
    # Builds the configuration named after this machine's hostname (flake.nix,
    # hosts)
    nrs = "sudo nixos-rebuild switch --flake .";

    # Apply this Home Manager configuration
    hms = "home-manager switch --flake ~/.config/home-manager#${config.home.username}";

    nfr = "cd /etc/nixos && sudo git pull --rebase && cp -r /etc/nixos/home-manager/* ~/.config/home-manager/ && nrs && hms";
    hmr = "cd /etc/nixos && sudo git pull --rebase && cp -r /etc/nixos/home-manager/* ~/.config/home-manager/ && hms";

    # z with fzf (zoxide's zi, see applications/consoles/zoxide.nix)
    fz = "zi";
  };

  # eza instead of ls, only when eza is installed system-wide (otherwise the
  # system-wide ls aliases stay)
  # https://github.com/eza-community/eza#command-line-options
  programs.bash.initExtra = ''
    if command -v eza >/dev/null; then
      alias ls="eza --icons=auto --group-directories-first"
      alias ll="eza --icons=auto --group-directories-first --long --git"
      alias la="eza --icons=auto --group-directories-first --long --git --all"
      alias lt="eza --icons=auto --tree --level=2"
    fi
  '';
}
