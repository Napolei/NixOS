# fzf key bindings (CTRL-T files, CTRL-R history, ALT-C cd) and defaults
# https://junegunn.github.io/fzf/shell-integration/
# https://github.com/junegunn/fzf#environment-variables

{ lib, vars, ... }:

let
  # Terminal palette number of a role, e.g. accent = color4 -> "4"
  index = name: lib.removePrefix "color" vars.theme.roles.${name};
in
{
  programs.bash.initExtra = ''
    # Only when fzf is installed system-wide
    if command -v fzf >/dev/null; then
      eval "$(fzf --bash)"
    fi
  '';

  home.sessionVariables = {
    # Use fd, so hidden files are found and .gitignore / fd ignores are respected
    FZF_DEFAULT_COMMAND = "fd --type f --hidden";
    FZF_CTRL_T_COMMAND = "fd --type f --hidden";
    FZF_ALT_C_COMMAND = "fd --type d --hidden";
    # Colors from the roles in theme.nix, as terminal palette numbers (the
    # palette is set from theme.colors, see terminal/terminal-colors.nix)
    FZF_DEFAULT_OPTS = builtins.concatStringsSep " " [
      "--height=40% --layout=reverse --border"
      "--color=16,hl:${index "accent"},hl+:${index "accent"},bg+:${index "surface"},info:${index "dimmed"},prompt:${index "accent"},pointer:${index "accent"},marker:${index "accent"},spinner:${index "accent"},border:${index "surface"}"
    ];
  };
}
