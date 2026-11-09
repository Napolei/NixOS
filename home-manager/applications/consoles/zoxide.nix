# zoxide: `z <dir>` jumps to a remembered directory, `zi` picks one with fzf
# https://github.com/ajeetdsouza/zoxide#installation

{ ... }:

{
  programs.bash.initExtra = ''
    # Only when zoxide is installed system-wide
    if command -v zoxide >/dev/null; then
      eval "$(zoxide init bash)"
    fi
  '';
}
