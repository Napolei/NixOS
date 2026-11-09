# fd global ignore file (~/.config/fd/ignore, same syntax as .gitignore)
# https://github.com/sharkdp/fd#excluding-specific-files-or-directories

{ ... }:

{
  xdg.configFile."fd/ignore".text = ''
    .git/
    node_modules/
    __pycache__/
    .venv/
  '';
}
