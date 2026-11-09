# tealdeer (tldr) settings (~/.config/tealdeer/config.toml)
# https://tealdeer-rs.github.io/tealdeer/config.html

{ ... }:

{
  xdg.configFile."tealdeer/config.toml".text = ''
    [display]
    compact = false
    use_pager = false

    [updates]
    # Download / refresh the pages automatically (run `tldr --update` once)
    auto_update = true
  '';
}
