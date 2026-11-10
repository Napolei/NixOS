# httpie settings (~/.config/httpie/config.json)
# https://httpie.io/docs/cli/config-file-directory

{ ... }:

{
  xdg.configFile."httpie/config.json".text = builtins.toJSON {
    # Options added to every http / https call. Style "auto": the terminal
    # colours, so it follows the theme like curlie
    default_options = [ "--style=auto" ];
  };
}
