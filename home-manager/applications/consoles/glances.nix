# glances settings (~/.config/glances/glances.conf)
# https://glances.readthedocs.io/en/latest/config.html

{ ... }:

{
  xdg.configFile."glances/glances.conf".text = ''
    [global]
    # Refresh every 2 seconds
    refresh=2
    # Updates come from nixpkgs
    check_update=false
  '';
}
