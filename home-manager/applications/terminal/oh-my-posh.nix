# oh-my-posh prompt from a theme file (prompt.ohMyPosh in vars.nix): a file
# in home-manager/oh-my-posh/, copied to ~/.config/oh-my-posh/, or a theme
# that comes with oh-my-posh. JSON files there get the theme colours
# (theme.nix: prompt) as the palette p:<name>; a palette in the file wins.
# Active when prompt.engine is "oh-my-posh" and oh-my-posh is installed
# system-wide (applications/terminal/oh-my-posh).
# https://ohmyposh.dev/docs/configuration/general

{ config, lib, vars, ... }:

let
  themeLib = import ../../theme-lib.nix { inherit lib vars; };
  cfg = vars.prompt.ohMyPosh;

  palette = lib.mapAttrs (name: hex: "#${hex}") (themeLib.promptColors themeLib.palette);

  # Theme name -> how bash finds the config: a file in ~/.config/oh-my-posh,
  # or a theme in the share folder of the installed oh-my-posh ("agnoster" or
  # "agnoster.omp.json")
  local = name: builtins.pathExists (../../oh-my-posh + "/${name}");
  configPath = name:
    if local name then
      ''"''${XDG_CONFIG_HOME:-$HOME/.config}"/oh-my-posh/${name}''
    else
      ''"$(dirname "$(readlink -f "$(command -v oh-my-posh)")")"/../share/oh-my-posh/themes/${lib.removeSuffix ".omp.json" name}.omp.json'';

  # The local theme files, JSON ones with the palette merged in
  configFile = name: {
    name = "oh-my-posh/${name}";
    value =
      let file = ../../oh-my-posh + "/${name}";
      in if lib.hasSuffix ".json" name then
        let theme = builtins.fromJSON (builtins.readFile file);
        in { text = builtins.toJSON (theme // { palette = palette // (theme.palette or { }); }); }
      else
        { source = file; };
  };
in
lib.mkIf (vars.prompt.engine == "oh-my-posh") {
  xdg.configFile = builtins.listToAttrs (map configFile (lib.filter local (lib.unique [ cfg.theme cfg.jetbrainsTheme ])));

  programs.bash.initExtra = ''
    # Only when oh-my-posh is installed system-wide
    if command -v oh-my-posh >/dev/null; then
      if [[ ''${TERMINAL_EMULATOR-} == JetBrains-JediTerm ]]; then
        eval "$(oh-my-posh init bash --config ${configPath cfg.jetbrainsTheme})"
      else
        eval "$(oh-my-posh init bash --config ${configPath cfg.theme})"
      fi
    fi
  '';

  programs.bash.bashrcExtra = ''
    # Automatically activate Poetry environments
    if [[ $- == *i* ]] && \
       [[ -f "pyproject.toml" ]] && \
       command -v poetry >/dev/null 2>&1 && \
       [[ -z "$VIRTUAL_ENV" ]]; then

        VENV_PATH=$(poetry env info --path 2>/dev/null)

        if [[ -f "$VENV_PATH/bin/activate" ]]; then
            source "$VENV_PATH/bin/activate"
        fi

        unset VENV_PATH
    fi
  '';
}
