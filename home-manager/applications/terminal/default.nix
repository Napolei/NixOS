# Settings for the terminal, its multiplexer, prompt and shell helpers
# (installed system-wide in /applications/terminal), and the terminal colours

{
  imports = [
    ./kitty.nix
    ./mcfly.nix
    ./oh-my-posh.nix
    ./pay-respects.nix
    ./powerline.nix
    ./tealdeer.nix
    ./terminal-colors.nix
    ./tmux.nix
  ];
}
