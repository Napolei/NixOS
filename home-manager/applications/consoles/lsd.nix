# lsd settings (~/.config/lsd/config.yaml, JSON is valid YAML)
# https://github.com/lsd-rs/lsd#config-file-content

{ ... }:

{
  xdg.configFile."lsd/config.yaml".text = builtins.toJSON {
    icons = {
      when = "auto";
      theme = "fancy";
    };
    date = "+%d.%m.%Y %H:%M";
    size = "short";
    sorting.dir-grouping = "first";
  };
}
