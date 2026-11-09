# pay-respects: run `fuck` (or `f`) to correct the previous command
# https://github.com/iffse/pay-respects#setup

{ ... }:

{
  programs.bash.initExtra = ''
    # Only when pay-respects is installed system-wide
    if command -v pay-respects >/dev/null; then
      eval "$(pay-respects bash --alias fuck)"
    fi
  '';
}
