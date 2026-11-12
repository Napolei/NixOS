# Home Manager template

Per-user settings for the NixOS configuration in this repository, as a standalone [Home Manager](https://github.com/nix-community/home-manager) flake.

Each user copies this folder to `~/.config/home-manager`, adjusts `vars.nix` and applies it without `sudo`. The template only holds settings (dotfiles, colours, aliases). The programs themselves are installed system-wide through `/applications` and `/system`, so a setting here only takes effect when its program is installed on the system.

## First-time setup

1. **Install the system.** Rebuild NixOS-WSL from the repository first (see the [main README](../README.md#setup)). This installs the programs and enables flakes. The examples below assume the repository is at `/etc/nixos`.

2. **Copy the template** to your home directory:

   ```bash
   mkdir -p ~/.config/home-manager
   cp -r /etc/nixos/home-manager/* ~/.config/home-manager/
   ```

3. **Adjust `~/.config/home-manager/vars.nix`** before the first switch. At least `user.username` and `user.homeDirectory`: your account. All options are described [below](#settings-varsnix).

4. **Apply it.** The first time, neither the `hms` alias nor necessarily the `home-manager` command exist:
   - The user from the system `vars.nix` already has `home-manager` (installed by `core/users.nix`).
   - Every other user gets it from a temporary shell.

   ```bash
   # Only if `home-manager` is not found:
   nix-shell -p home-manager

   home-manager switch --flake ~/.config/home-manager#<username>
   ```

   `<username>` is `user.username` from step 3. The first switch creates `flake.lock` in `~/.config/home-manager` and downloads Home Manager, which takes a while.

   Files that are already in the way (e.g. an existing `~/.bashrc`) are moved to `<file>.backup` instead of stopping the switch.

   From now on, `home-manager` is installed in your profile (`programs.home-manager.enable`) and the [aliases](#aliases) exist in new terminals.

5. **Open a new terminal** to get the aliases and colours.

## Applying changes

| Command | What it does |
|---|---|
| `hms` | Apply `~/.config/home-manager` |
| `hmr` | Pull the repository in `/etc/nixos`, copy this template over `~/.config/home-manager`, apply it |
| `nfr` | Same as `hmr`, plus a system rebuild before |
| `home-manager build --flake ~/.config/home-manager#<username>` | Build without applying |
| `nix flake update --flake ~/.config/home-manager` | Update nixpkgs and Home Manager, then run `hms` |

> `hmr` and `nfr` copy the template over your local copy, **including `vars.nix` and `theme.nix`**. If your settings differ from the repository, change them in the repository, or use `hms` after editing `~/.config/home-manager` directly.

If `hms` ends with "systemd is degraded", a user service failed. Show it with `systemctl --user --failed` and its log with `journalctl --user -u <service> -b`. After fixing it, `systemctl --user reset-failed`.

## Settings (`vars.nix`)

| Setting | What it does |
|---|---|
| `user.username`, `user.homeDirectory` | Your account; also the name after `#` in the switch command |
| `stateVersion` | Home Manager version of the first activation, don't change it later |
| `prompt.engine` | Program that draws the bash prompt: `oh-my-posh` (default) or `powerline` |
| `prompt.ohMyPosh.theme` | oh-my-posh theme of all terminals except the JetBrains ones, by file name: a file in `oh-my-posh/` (default `theme.omp.json`, the two-line prompt with user, path, git, Python, Node.js, run time) or a theme that comes with oh-my-posh, e.g. `agnoster` ([previews](https://ohmyposh.dev/docs/themes)). JSON files in `oh-my-posh/` can use the `theme.nix` colours as `p:<name>` (`text`, `dark`, `user`, `path`, `accent`, `dimmed`, `warning`, `error`); a `palette` in the file wins. [How to write a theme](https://ohmyposh.dev/docs/configuration/general) |
| `prompt.ohMyPosh.jetbrainsTheme` | The same for the terminal of PyCharm and the other JetBrains IDEs. Default `theme-jetbrains.omp.json`: `theme.omp.json` with the right side at the end of the left one |
| `prompt.powerline.theme` | Powerline theme in all terminals except the JetBrains ones: `default` (git branch on the right side of the line) or `default_leftonly` (branch next to the path) |
| `prompt.powerline.jetbrainsTheme` | The same for the terminal of PyCharm and the other JetBrains IDEs (`TERMINAL_EMULATOR=JetBrains-JediTerm`). Keep `default_leftonly`: that terminal can't draw the right side |
| `theme` | The colour profile, imported from `theme.nix` (see [below](#theme-themenix)) |

## Theme (`theme.nix`)

The colour profile of the terminal and its tools is in `theme.nix`, imported by `vars.nix` as `theme`. The base values at the top are referenced by the sections below them, e.g. `prompt.user = highlight;`. Change a base value to change it everywhere; replace a reference with a value to change only that one.

| Setting | What it does |
|---|---|
| `colors` | The 16-colour palette, plus `background` and `foreground`. It was generated once with pywal16 from the former wallpaper and is kept as fixed hex values; edit them to change the colours |
| `alerts` | Error and warning colours (`error`, `warning`) of the true-colour programs (btop, Neovim, the prompt, tmux, yazi, superfile, micro, oxker), red and yellow so they stand out from the palette |
| `roles` | Which palette colour is the accent, the secondary colour, the surface (selection, borders) and dimmed text. `error` and `warning` here are only used by programs limited to the 16 terminal colours (nano) |
| `highlight`, `raisedLighten` | Colour-blind friendly highlights in the prompt and terminal programs: `highlight` is a light role or palette colour (active tab, selection, ripgrep matches, with dark text), `raisedLighten` how many percent the background is lightened for status bars and the prompt's path. Neighbouring elements differ in lightness, not only in hue |
| `font` | Terminal font |
| `prompt` | Prompt colours (oh-my-posh and powerline): `user`, the background of the user name, and `pathLighten`, how much the background is lightened behind the path and the git branch. By default `highlight` and `raisedLighten` |
| `kitty.font`, `kitty.fontSize` | kitty font and size in points (WSLg doesn't scale for high-DPI screens) |

The colour files of all programs are written by the functions in `theme-lib.nix`.

### How each program gets the colours

| Program | How it gets the colours |
|---|---|
| kitty | `~/.config/kitty/colors.conf`, included by `kitty.conf` |
| Other terminals (e.g. Windows Terminal) | Escape sequences for the palette, text, background and cursor when bash starts (`applications/terminal/terminal-colors.nix`) |
| bat, fzf, nano | Terminal colours chosen by role (bat theme `ansi`, fzf `--color=16`, `~/.config/nano/nanorc`) |
| Prompt | oh-my-posh: the palette merged into the JSON themes in `~/.config/oh-my-posh/`; powerline: `~/.config/powerline/colors.json`. Both in true colour, backgrounds from `theme.nix` (`prompt`) |
| btop | `~/.config/btop/themes/theme.theme`, set as `color_theme` in `btop.conf` on every `hms` (the rest of `btop.conf` stays editable) |
| tmux, yazi, superfile, micro, oxker | `~/.config/tmux/colors.conf` (sourced by `tmux.conf`), `~/.config/yazi/theme.toml`, superfile theme `theme` (set in superfile's `config.toml` on every `hms`), micro colour scheme `theme` (set in micro's `settings.json`), `~/.config/oxker/config.toml`: selections and the active tab dark on `highlight`, status bars raised |
| ripgrep | `~/.config/ripgrep/config`, read through `RIPGREP_CONFIG_PATH` (new logins): matches dark on `highlight`, paths in the accent colour |
| httpie, curlie, procs, gping, dust, fd | Terminal colours (httpie style `auto`) |
| Neovim | Colour scheme `theme` (`~/.config/nvim/colors/theme.lua`); the terminal background shows through |
| eza, lsd, glances, nnn and other CLI tools | Terminal colours (always) |

## Structure

```text
home-manager/
├── flake.nix                 # Standalone flake (homeConfigurations.<username>)
├── home.nix                  # Entry point: imports, bash, Home Manager itself
├── vars.nix                  # Your settings
├── theme.nix                 # Your colour profile: palette, roles, font
├── theme-lib.nix             # Colour files of all programs from theme.nix
├── shell/aliases.nix         # All user aliases
├── shell/env.nix             # User environment variables
└── applications/             # Settings of system-wide programs, in the same groups as /applications
    ├── containers/           # oxker
    ├── development/          # git
    ├── editors/              # micro, nano, neovim
    ├── files/                # broot, lsd, nnn, superfile, yazi, zoxide
    ├── network/              # httpie
    ├── search/               # fd, fzf, ripgrep
    ├── system/               # btop, glances
    ├── terminal/             # kitty, mcfly, oh-my-posh, pay-respects, powerline, tealdeer, tmux,
    │                         # terminal-colors.nix (palette for terminals other than kitty)
    └── text/                 # bat
```

To add settings for another program: create a `.nix` file under `applications/`, add it to the `imports` of the folder's `default.nix` and run `hms`. Use `xdg.configFile` or a Home Manager `programs.<name>` module with `package = null`, so nothing gets installed per user.

## Shell

`shell/aliases.nix` holds all user aliases, on top of the system-wide ones in `/system/shell/aliases.nix`:

### Aliases

| Alias | Command |
|---|---|
| `nrs` | `sudo nixos-rebuild switch --flake .` (run in `/etc/nixos`), builds the host named like this machine |
| `hms`, `hmr`, `nfr` | See [Applying changes](#applying-changes) |
| `ls`, `ll`, `la`, `lt` | eza with icons; long, long with hidden files, tree |
| `fz` | `zi`, interactive directory jump (zoxide + fzf) |
| `fuck` | Fix the last command (pay-respects) |

### Environment variables

`shell/env.nix` holds the user environment variables, on top of the system-wide ones in `/environment` (its own flake). A variable with the same name overrides the system-wide one. They take effect in new login shells.

| Variable | Value |
|---|---|
| `EDITOR`, `VISUAL` | `micro` |
| `PAGER` | `less` |
| `LESS` | `-RF`: keep colours, quit when the text fits on one screen |

Variables of a single program are in that program's settings (e.g. `applications/files/nnn.nix`). `applications/text/bat.nix` sets `MANPAGER` and `MANROFFOPT` for coloured man pages through bat, only when bat is installed.

Shell integrations set up by the console tool settings: zoxide (`z`), fzf key bindings, mcfly history search (<kbd>Ctrl</kbd>+<kbd>R</kbd>).
