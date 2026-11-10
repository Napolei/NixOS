# nnn settings (environment variables)
# https://github.com/jarun/nnn/wiki/Usage#configuration

{ ... }:

{
  home.sessionVariables = {
    # d: detail mode, H: show hidden files
    NNN_OPTS = "dH";
    # Bookmarks, open with b + key
    NNN_BMS = "h:~;d:~/Downloads;c:~/.config";
  };
}
